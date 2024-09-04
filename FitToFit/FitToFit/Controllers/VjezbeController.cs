using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VjezbeController : BaseCRUDController<Model.Vjezbe, VjezbeSearchObject, VjezbeInsertRequest, VjezbeUpdateRequest>
    {
        private readonly IVjezbeService _vjezbeService;
        public VjezbeController(ILogger<BaseController<Vjezbe, VjezbeSearchObject>> logger, IVjezbeService service)
            : base(logger, service)
        {
            _vjezbeService = service;
        }
    }
}