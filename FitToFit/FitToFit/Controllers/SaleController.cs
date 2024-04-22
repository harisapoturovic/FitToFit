using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;

namespace FitToFit.Controllers
{
    [ApiController]
    public class SaleController : BaseController<Model.Sale, BaseSearchObject>
    {
        public SaleController(ILogger<BaseController<Sale, BaseSearchObject>> logger, ISaleService service)
            :base(logger, service)
        {
        }
    }
}