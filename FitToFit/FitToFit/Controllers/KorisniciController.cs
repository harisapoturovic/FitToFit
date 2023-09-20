using FitToFit.Model;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : ControllerBase
    {
        private readonly IKorisniciService _korisniciService;
        private readonly ILogger<WeatherForecastController> _logger;

        public KorisniciController(ILogger<WeatherForecastController> logger, IKorisniciService korisniciService)
        {
            _logger = logger;
            _korisniciService = korisniciService;   
        }

        [HttpGet()]
        public IEnumerable<Model.Korisnici> Get()
        {
           return _korisniciService.Get();   
        }
    }
}