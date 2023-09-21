using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    public class VrsteTreningaController : BaseController<Model.VrsteTreninga, VrsteTreningaSearchObject>
    {
        public VrsteTreningaController(ILogger<BaseController<VrsteTreninga, VrsteTreningaSearchObject>> logger, IVrsteTreningaService service)
            :base(logger, service)
        {
        }
    }
}