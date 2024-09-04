using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IRecommenderService : ICRUDService<Model.Recommender, RecommenderSearchObject, RecommenderInsertRequest, RecommenderUpdateRequest>
    {
        Task<Model.Recommender?> GetById(int id, CancellationToken cancellationToken = default);
        Task<PagedResult<Model.Recommender>> TrainTreninziModelAsync(CancellationToken cancellationToken = default);
        Task DeleteAllRecommendations(CancellationToken cancellationToken = default);
    }
}