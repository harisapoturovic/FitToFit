using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TreninziController : BaseCRUDController<Model.Treninzi, TreninziSearchObject, TreninziInsertRequest, TreninziUpdateRequest>
    {
        public TreninziController(ILogger<BaseController<Treninzi, TreninziSearchObject>> logger, ITreninziService service)
            : base(logger, service)
        {

        }
    }
}