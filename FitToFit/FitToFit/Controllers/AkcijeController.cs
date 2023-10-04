using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AkcijeController : BaseCRUDController<Model.Akcije, AkcijeSearchObject, AkcijeInsertRequest, AkcijeUpdateRequest>
    {
        public AkcijeController(ILogger<BaseController<Akcije, AkcijeSearchObject>> logger, IAkcijeService service)
            : base(logger, service)
        {

        }

        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Akcije> Activate(int id)
        {
            return await (_service as IAkcijeService).Activate(id);
        }

        [HttpPut("{id}/archive")]
        public virtual async Task<Model.Akcije> Archive(int id)
        {
            return await (_service as IAkcijeService).Archive(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IAkcijeService).AllowedActions(id);
        }
    }
}