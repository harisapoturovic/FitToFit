using AutoMapper;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;

namespace FitToFit.Services
{
    public class SaleService : BaseService<Model.Sale, Sale, BaseSearchObject>, ISaleService
    {
        public SaleService(_200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }
    }
}
