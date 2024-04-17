using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    public class ClanarineController : BaseController<Model.Clanarine, BaseSearchObject>
    {
        public ClanarineController(ILogger<BaseController<Clanarine, BaseSearchObject>> logger, IClanarineService service)
            :base(logger, service)
        {
        }
    }
}