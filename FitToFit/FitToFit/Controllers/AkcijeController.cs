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
    }
}