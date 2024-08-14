using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PlacanjaController : BaseCRUDController<Model.Placanja, PlacanjaSearchObject, PlacanjaInsertRequest, PlacanjaUpdateRequest>
    {
        public PlacanjaController(ILogger<BaseController<Placanja, PlacanjaSearchObject>> logger, IPlacanjaService service)
            : base(logger, service)
        {

        }       
    }
}