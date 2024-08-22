using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.AkcijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using Vjezbe = FitToFit.Services.Database.Vjezbe;
using _200048Context = FitToFit.Services.Database._200048Context;
using System.Text.RegularExpressions;

namespace FitToFit.Services
{
    public class VjezbeService : BaseCRUDService<Model.Vjezbe, Vjezbe, VjezbeSearchObject, VjezbeInsertRequest, VjezbeUpdateRequest>, IVjezbeService
    {
        public VjezbeService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Vjezbe> AddFilter(IQueryable<Vjezbe> query, VjezbeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            return base.AddFilter(query, search);
        }    

        public override async Task<Model.Vjezbe> Delete(int id)
        {
            var vjezba = _context.Vjezbes.Include(r => r.TreninziVjezbes).FirstOrDefault(r => r.VjezbaId == id);

            if (vjezba != null)
            {
                _context.TreninziVjezbes.RemoveRange(vjezba.TreninziVjezbes);
                _context.Vjezbes.Remove(vjezba);

                _context.SaveChanges();
            }
            return _mapper.Map<Model.Vjezbe>(vjezba);
        }

        public class VjezbeFeatureVector
        {
            public int VjezbaId { get; set; }
            public string Namjena { get; set; }
        }

        public static class SimilarityService
        {
            public static double CalculateJaccardSimilarity(string text1, string text2)
            {
                var words1 = Regex.Split(text1.ToLower(), @"\W+").Distinct().ToList();
                var words2 = Regex.Split(text2.ToLower(), @"\W+").Distinct().ToList();

                var intersection = words1.Intersect(words2).Count();
                var union = words1.Union(words2).Count();

                return (double)intersection / union;
            }
        }

        // CONTENT-BASED FILTERING
        public async Task<PagedResult<Model.Vjezbe>> Recommend(int userId)
        {
            // Učitaj sve rezervacije korisnika i poveži ih sa terminima i treningom
            var userTrainingIds = await _context.Rezervacijes
                .Where(r => r.KorisnikId == userId)
                .SelectMany(r => r.RezervacijaStavkes)
                .Select(rs => rs.Termin.TreningId)
                .Distinct()
                .ToListAsync();

            if (!userTrainingIds.Any())
            {
                return new PagedResult<Model.Vjezbe>
                {
                    Result = new List<Model.Vjezbe>(),
                    Count = 0
                };
            }

            // Učitaj sve treninge koje je korisnik već rezervisao
            var userTrainingNamjena = await _context.Treninzis
                .Where(t => userTrainingIds.Contains(t.TreningId))
                .Select(t => new { t.TreningId, t.Namjena })
                .ToListAsync();

            // Učitaj sve vježbe koje su vezane za treninge koje je korisnik već rezervisao
            var userTrainingExercises = await _context.TreninziVjezbes
                .Where(tv => userTrainingIds.Contains(tv.TreningId))
                .Include(tv => tv.Vjezba)
                .ToListAsync();

            var userTrainingExerciseIds = userTrainingExercises.Select(tv => tv.Vjezba.VjezbaId).ToList();

            // Učitaj sve vježbe koje korisnik još nije rezervisao
            var allOtherExercises = await _context.Vjezbes
                .Where(v => !userTrainingExerciseIds.Contains(v.VjezbaId))
                .ToListAsync();

            // Pronađi namjenu za svaku vježbu
            var exerciseNamjenaMap = await _context.TreninziVjezbes
                .Where(tv => allOtherExercises.Select(e => e.VjezbaId).Contains(tv.VjezbaId))
                .Select(tv => new
                {
                    tv.VjezbaId,
                    Namjena = _context.Treninzis.Where(t => t.TreningId == tv.TreningId).Select(t => t.Namjena)
                    .FirstOrDefault() ?? string.Empty
                })
                .GroupBy(x => x.VjezbaId) // Grupisanje da se izbjegnu duplikati
                .Select(g => g.First()) // Uzmi prvi element iz svake grupe
                .ToDictionaryAsync(x => x.VjezbaId, x => x.Namjena);

            var similarityScores = new List<Tuple<Vjezbe, double>>();

            PagedResult<Model.Vjezbe> pagedResult = new PagedResult<Model.Vjezbe>();

            foreach (var exercise in allOtherExercises)
            {
                var exerciseNamjena = exerciseNamjenaMap.TryGetValue(exercise.VjezbaId, out var namjena) ? namjena : string.Empty;

                var exerciseFeatureVector = new VjezbeFeatureVector
                {
                    VjezbaId = exercise.VjezbaId,
                    Namjena = exerciseNamjena
                };

                double similarity = 0;

                // Usporedi s namjenama treninga koje je korisnik rezervisao
                foreach (var trainingNamjena in userTrainingNamjena.Select(t => t.Namjena))
                {
                    var trainingFeatureVector = new VjezbeFeatureVector { Namjena = trainingNamjena };
                    similarity += SimilarityService.CalculateJaccardSimilarity(exerciseFeatureVector.Namjena, trainingFeatureVector.Namjena);
                }

                similarityScores.Add(new Tuple<Vjezbe, double>(exercise, similarity));
            }

            // Preporuči vježbe sa najvećom sličnosti
            var recommendedExercises = similarityScores.OrderByDescending(x => x.Item2)
                                                      .Select(x => x.Item1)
                                                      .Take(5)
                                                      .ToList();

            pagedResult.Result = _mapper.Map<List<Model.Vjezbe>>(recommendedExercises);
            pagedResult.Count = recommendedExercises.Count;

            return pagedResult;
        }
    }
}
