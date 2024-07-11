using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciNovostiController : BaseCRUDController<Model.KorisniciNovosti, KorisniciNovostiSearchObject, KorisniciNovostiInsertRequest, KorisniciNovostiInsertRequest>
    {
        public KorisniciNovostiController(ILogger<BaseController<KorisniciNovosti, KorisniciNovostiSearchObject>> logger, IKorisniciNovostiService service)
            : base(logger, service)
        {

        }       
    }
}