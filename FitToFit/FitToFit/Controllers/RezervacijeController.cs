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
    }
}