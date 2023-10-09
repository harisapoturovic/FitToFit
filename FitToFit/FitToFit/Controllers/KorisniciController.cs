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
    public class KorisniciController : BaseCRUDController<Model.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Korisnici, KorisniciSearchObject>> logger, IKorisniciService service)
            :base(logger, service)
        {
          
        }

        [Authorize(Roles = "Administrator")] //[AllowAnonymous]
        public override Task<Korisnici> Insert([FromBody] KorisniciInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}