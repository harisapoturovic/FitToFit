using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostiController : BaseCRUDController<Model.Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>
    {
        public NovostiController(ILogger<BaseController<Novosti, NovostiSearchObject>> logger, INovostiService service)
            :base(logger, service)
        {
          
        }

    }
}