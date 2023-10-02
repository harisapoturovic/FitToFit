using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TreninziClanarineController : BaseCRUDController<Model.TreninziClanarine, TreninziClanarineSearchObject, TreninziClanarineInsertRequest, TreninziClanarineUpdateRequest>
    {
        public TreninziClanarineController(ILogger<BaseController<TreninziClanarine, TreninziClanarineSearchObject>> logger, ITreninziClanarine service)
            : base(logger, service)
        {

        }
    }
}