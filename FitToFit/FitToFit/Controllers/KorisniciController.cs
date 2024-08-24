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
        private readonly IKorisniciService _korisniciService;
        public KorisniciController(ILogger<BaseController<Korisnici, KorisniciSearchObject>> logger, IKorisniciService service)
            :base(logger, service)
        {
            _korisniciService = service;
        }

        [AllowAnonymous] //[Authorize(Roles = "Administrator")] 
        public override Task<Korisnici> Insert([FromBody] KorisniciInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [AllowAnonymous] 
        public override Task<PagedResult<Korisnici>> Get([FromQuery] KorisniciSearchObject search)
        {
            return base.Get(search);
        }

        [AllowAnonymous]
        public override Task<Korisnici> GetById(int id)
        {
            return base.GetById(id);
        }

        [HttpPost("{userId}/change-password")]
        public async Task<IActionResult> ChangePassword(int userId, [FromBody] KorisniciChangePassword changePasswordModel)
        {
            try
            {
                if (userId != changePasswordModel.Id)
                {
                    return Forbid("Nemate permisije da mijenjate lozinku.");
                }

                await _korisniciService.ChangePasswordAsync(changePasswordModel);

                return Ok(new { Message = "Lozinka uspješno promijenjena." }); 
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message); 
            }
        }

        [HttpPost("{userId}/change-username")]
        public async Task<IActionResult> ChangeUsername(int userId, [FromBody] KorisniciChangeUsername changeUsernameModel)
        {
            try
            {
                if (userId != changeUsernameModel.Id)
                {
                    return Forbid("Nemate permisije da mijenjate username.");
                }

                await _korisniciService.ChangeUsernameAsync(changeUsernameModel);

                return Ok(new { Message = "Username promijenjen uspješno." }); 
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message); 
            }
        }
    }
}