using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VjezbeTreninziController : BaseController<Model.TreninziVjezbe, BaseSearchObject>
    {
        IVjezbeTreninziService _service;
        public VjezbeTreninziController(ILogger<BaseController<TreninziVjezbe, BaseSearchObject>> logger, IVjezbeTreninziService service)
            :base(logger, service)
        {
          _service = service;
        }

        [HttpPost]
        public virtual async Task<Model.TreninziVjezbe> Insert([FromBody] VjezbeTreninziInsertRequest insert)
        {
            return await _service.Insert(insert);
        }

        [HttpDelete("{id}")]
        public virtual async Task<Model.TreninziVjezbe> Delete(int id)
        {
            return await _service.Delete(id);
        }

    }
}