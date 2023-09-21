using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [Route("[controller]")]
    public class BaseCRUDController<T, Tsearch, Tinsert, Tupdate> : BaseController<T, Tsearch> where T : class where Tsearch : class
    {
        protected new readonly ICRUDService<T, Tsearch, Tinsert, Tupdate> _service;
        protected readonly ILogger<BaseController<T, Tsearch>> _logger; //ako ga ne budem koristila samo izb

        public BaseCRUDController(ILogger<BaseController<T, Tsearch>> logger, ICRUDService<T, Tsearch, Tinsert, Tupdate> service)
            :base(logger, service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        public virtual async Task<T> Insert([FromBody] Tinsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody] Tupdate update)
        {
            return await _service.Update(id, update);
        }

    }
}