using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TerminiController : BaseCRUDController<Model.Termini, TerminiSearchObject, TerminiInsertRequest, TerminiUpdateRequest>
    {
        public TerminiController(ILogger<BaseController<Termini, TerminiSearchObject>> logger, ITerminiService service)
            : base(logger, service)
        {

        }
    }
}