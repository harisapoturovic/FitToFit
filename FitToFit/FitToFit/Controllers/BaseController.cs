using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [Route("[controller]")]
    public class BaseController<T, Tsearch> : ControllerBase where T : class where Tsearch : class
    {
        protected readonly IService<T, Tsearch> _service;
        protected readonly ILogger<BaseController<T, Tsearch>> _logger; //ako ga ne budem koristila samo izb

        public BaseController(ILogger<BaseController<T, Tsearch>> logger, IService<T, Tsearch> service)
        {
            _logger = logger;
            _service = service; 
        }

        [HttpGet()]
        public async Task<PagedResult<T>> Get([FromQuery] Tsearch? search=null)
        {
           return await _service.Get(search);   
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
}