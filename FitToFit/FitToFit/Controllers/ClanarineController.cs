using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    public class ClanarineController : BaseController<Model.Clanarine, ClanarineSearchObject>
    {
        public ClanarineController(ILogger<BaseController<Clanarine, ClanarineSearchObject>> logger, IClanarineService service)
            :base(logger, service)
        {
        }
    }
}