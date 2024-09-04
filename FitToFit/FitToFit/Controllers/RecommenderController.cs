using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RecommenderController
    {
        private readonly IRecommenderService _recommenderService;


        public RecommenderController(IRecommenderService service)
        {
            _recommenderService = service;
        }

        [Authorize]
        [HttpGet("{treningId}")]
        public virtual async Task<Model.Recommender?> Get(int treningId, CancellationToken cancellationToken = default)
        {
            return await _recommenderService.GetById(treningId, cancellationToken);
        }

        [Authorize]
        [HttpPost("TrainModelAsync")]
        public virtual async Task<PagedResult<Model.Recommender>> TrainModel(CancellationToken cancellationToken = default)
        {
            return await _recommenderService.TrainTreninziModelAsync(cancellationToken);
        }

        [Authorize]
        [HttpDelete("ClearRecommendations")]
        public virtual async Task ClearRecommendations(CancellationToken cancellationToken = default)
        {
            await _recommenderService.DeleteAllRecommendations();
        }

    }
}