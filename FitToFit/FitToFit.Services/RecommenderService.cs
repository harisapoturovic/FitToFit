using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using _200048Context = FitToFit.Services.Database._200048Context;
using Recommender = FitToFit.Services.Database.Recommender;
using Microsoft.ML;
using Microsoft.ML.Trainers;

namespace FitToFit.Services
{
    public class RecommenderService : BaseCRUDService<Model.Recommender, Recommender, RecommenderSearchObject, RecommenderInsertRequest, RecommenderUpdateRequest>, IRecommenderService
    {
        protected readonly IMapper _mapper;
        private readonly _200048Context _context;
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        public RecommenderService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
            _mapper = mapper;
            _context = context;
        }

        public async Task<Model.Recommender?> GetById(int id, CancellationToken cancellationToken = default)
        {
            var entity = await _context.Recommenders.FirstOrDefaultAsync(r => r.TreningId == id, cancellationToken);

            if (entity is null)
                return null;

            return _mapper.Map<Model.Recommender>(entity);
        }

        public async Task DeleteAllRecommendations(CancellationToken cancellationToken = default)
        {
            await _context.Recommenders.ExecuteDeleteAsync(cancellationToken);
        }

        public List<Model.Treninzi> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Rezervacijes
                        .Include(r => r.RezervacijaStavkes)
                        .ThenInclude(rs => rs.Termin)
                        .ThenInclude(t => t.Trening)
                        .ToList();

                    var data = new List<TreninziPreporuka>();

                    foreach (var k in tmpData)
                    {
                        if (k.RezervacijaStavkes.Count > 0)
                        {
                            var distinctItemId = k.RezervacijaStavkes
                                .Select(t => t.Termin.TreningId)
                                .Distinct()
                                .ToList();

                            distinctItemId.ForEach(r =>
                            {
                                var relatedItems = k.RezervacijaStavkes
                                .Select(t => t.Termin.Trening).Where(tr => tr.TreningId != r).ToList();

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new TreninziPreporuka()
                                    {
                                        TreningId = (uint)r,
                                        CoTreningId = (uint)z.TreningId,
                                    });
                                }
                            });
                        }
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(TreninziPreporuka.TreningId);
                    options.MatrixRowIndexColumnName = nameof(TreninziPreporuka.CoTreningId);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;

                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }

            var treninzi = _context.Treninzis.Where(x => x.TreningId != id).ToList();

            var predictionResult = new List<Tuple<Database.Treninzi, float>>();

            foreach (var trening in treninzi)
            {

                var predictionengine = mlContext.Model.CreatePredictionEngine<TreninziPreporuka, CoTreningPrediction>(model);
                var prediction = predictionengine.Predict(
                                         new TreninziPreporuka()
                                         {
                                             TreningId = (uint)id,
                                             CoTreningId = (uint)trening.TreningId
                                         });


                predictionResult.Add(new Tuple<Database.Treninzi, float>(trening, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<Model.Treninzi>>(finalResult);
        }

        public async Task<PagedResult<Model.Recommender>> TrainTreninziModelAsync(CancellationToken cancellationToken = default)
        {
            var treninzi = await _context.Treninzis.ToListAsync(cancellationToken);

            var brojZapisa = await _context.Rezervacijes.CountAsync(cancellationToken);


            if (treninzi.Count() > 4 && brojZapisa > 8)
            {
                List<Recommender> recommendList = new List<Recommender>();

                foreach (var trening in treninzi)
                {
                    var recommendedTreninzi = Recommend(trening.TreningId);

                    var resultRecoomend = new Database.Recommender()
                    {
                        TreningId = trening.TreningId,
                        CoTreningId1 = recommendedTreninzi[0].TreningId,
                        CoTreningId2 = recommendedTreninzi[1].TreningId,
                        CoTreningId3 = recommendedTreninzi[2].TreningId
                    };
                    recommendList.Add(resultRecoomend);
                }
                await CreateNewRecommendation(recommendList, cancellationToken);
                await _context.SaveChangesAsync();

                return new PagedResult<Model.Recommender>
                {
                    Result = _mapper.Map<List<Model.Recommender>>(recommendList),
                    Count = recommendList.Count
                };
            }
            else
            {
                throw new Exception("Not enough data to do recommmedation");
            }
        }

        public async Task CreateNewRecommendation(List<Database.Recommender> results, CancellationToken cancellationToken = default)
        {
            var list = await _context.Recommenders.ToListAsync();
            var treninziCount = await _context.Treninzis.CountAsync(cancellationToken);
            var recordCount = await _context.Recommenders.CountAsync();

            if (recordCount != 0)
            {
                if (recordCount > treninziCount)
                {
                    for (int i = 0; i < treninziCount; i++)
                    {
                        list[i].TreningId = results[i].TreningId;
                        list[i].CoTreningId1 = results[i].CoTreningId1;
                        list[i].CoTreningId2 = results[i].CoTreningId2;
                        list[i].CoTreningId3 = results[i].CoTreningId3;
                    }

                    for (int i = treninziCount; i < recordCount; i++)
                    {
                        _context.Recommenders.Remove(list[i]);
                    }
                }
                else
                {
                    for (int i = 0; i < _context.Recommenders.Count(); i++)
                    {
                        list[i].TreningId = results[i].TreningId;
                        list[i].CoTreningId1 = results[i].CoTreningId1;
                        list[i].CoTreningId2 = results[i].CoTreningId2;
                        list[i].CoTreningId3 = results[i].CoTreningId3;
                    }
                    var num = results.Count() - _context.Recommenders.Count();

                    if (num > 0)
                    {
                        for (int i = results.Count() - num; i < results.Count(); i++)
                        {
                            await _context.Recommenders.AddAsync(results[i]);
                        }
                    }
                }
            }
            else
            {
                await _context.Recommenders.AddRangeAsync(results);
            }
        }
    }
}
