using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
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

        [HttpGet("getTop3Terms")]
        public virtual async Task<List<Model.OdabraniTermini>> GetTop3Terms(string? order = null)
        {
            return await (_service as IRezervacijaStavkeService).GetTop3Terms(order);
        }
    }
}