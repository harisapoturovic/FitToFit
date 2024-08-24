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
    public class RezervacijaStavkeController : BaseController<Model.RezervacijaStavke, BaseSearchObject>
    {
        public RezervacijaStavkeController(ILogger<BaseController<RezervacijaStavke, BaseSearchObject>> logger, IRezervacijaStavkeService service)
            :base(logger, service)
        {
        }

        [HttpGet("getTop3Termina")]
        [AllowAnonymous]
        public virtual async Task<List<Model.OdabraniTermini>> getTop3Termina(string? order = null)
        {
            return await (_service as IRezervacijaStavkeService).getTop3Termina(order);
        }

        [HttpGet("getProfitForLast3Years")]
        [AllowAnonymous]
        public virtual async Task<Model.Profit> GetProfitForLast3Years()
        {
            return await (_service as IRezervacijaStavkeService).GetProfitForLast3Years();
        }
    }
}