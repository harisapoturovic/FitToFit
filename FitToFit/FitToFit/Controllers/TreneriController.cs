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
    public class TreneriController : BaseCRUDController<Model.Treneri, TreneriSearchObject, TreneriInsertRequest, TreneriUpdateRequest>
    {
        public TreneriController(ILogger<BaseController<Treneri, TreneriSearchObject>> logger, ITreneriService service)
            :base(logger, service)
        {
          
        }

        [AllowAnonymous]
        public override Task<PagedResult<Treneri>> Get([FromQuery] TreneriSearchObject search)
        {
            return base.Get(search);
        }

    }
}