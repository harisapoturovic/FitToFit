using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RezervacijeController : BaseCRUDController<Model.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        public RezervacijeController(ILogger<BaseController<Rezervacije, RezervacijeSearchObject>> logger, IRezervacijeService service)
            : base(logger, service)
        {

        }
        
        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Rezervacije> Activate(int id)
        {
            return await (_service as IRezervacijeService).Activate(id);
        }

        [HttpPut("{id}/cancel")]
        public virtual async Task<Model.Rezervacije> Cancel(int id)
        {
            return await (_service as IRezervacijeService).Cancel(id);
        }

        [HttpPut("{id}/refuse")]
        public virtual async Task<Model.Rezervacije> Refuse(int id)
        {
            return await (_service as IRezervacijeService).Refuse(id);
        }

        [HttpPut("{id}/archive")]
        public virtual async Task<Model.Rezervacije> Archive(int id)
        {
            return await (_service as IRezervacijeService).Archive(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IRezervacijeService).AllowedActions(id);
        }
    }
}