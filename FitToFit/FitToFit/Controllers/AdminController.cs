using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AdminController : BaseCRUDController<Model.Admin, BaseSearchObject, AdminInsertRequest, AdminUpdateRequest>
    {
        public AdminController(ILogger<BaseController<Admin, BaseSearchObject>> logger, IAdminService service)
            :base(logger, service)
        {
          
        }

    }
}