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

        [Authorize(Roles = "Administrator")] //[AllowAnonymous]
        public override Task<Korisnici> Insert([FromBody] KorisniciInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [HttpPost("{userId}/change-password")]
        public async Task<IActionResult> ChangePassword(int userId, [FromBody] KorisniciChangePassword changePasswordModel)
        {
            try
            {
                if (userId != changePasswordModel.Id)
                {
                    return Forbid("You don't have permission to change this user's password.");
                }

                await _korisniciService.ChangePasswordAsync(changePasswordModel);

                return Ok(new { Message = "Password changed successfully." }); // 200 OK with a success message
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message); // 500 Internal Server Error
            }
        }
    }
}