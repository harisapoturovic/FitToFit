using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OcjeneController : BaseCRUDController<Model.Ocjene, OcjeneSearchObject, OcjeneInsertRequest, OcjeneInsertRequest>
    {
        public OcjeneController(ILogger<BaseController<Ocjene, OcjeneSearchObject>> logger, IOcjeneService service)
            :base(logger, service)
        {
          
        }

    }
}