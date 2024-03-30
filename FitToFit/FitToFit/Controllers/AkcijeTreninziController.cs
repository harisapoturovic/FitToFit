using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AkcijeTreninziController : BaseController<Model.AkcijeTreninzi, BaseSearchObject>
    {
        IAkcijeTreninziService _service;
        public AkcijeTreninziController(ILogger<BaseController<AkcijeTreninzi, BaseSearchObject>> logger, IAkcijeTreninziService service)
            :base(logger, service)
        {
          _service = service;
        }

        [HttpPost]
        public virtual async Task<Model.AkcijeTreninzi> Insert([FromBody] AkcijeTreninziInsertRequest insert)
        {
            return await _service.Insert(insert);
        }

        [HttpDelete("{id}")]
        public virtual async Task<Model.AkcijeTreninzi> Delete(int id)
        {
            return await _service.Delete(id);
        }

    }
}