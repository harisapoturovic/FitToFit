using AutoMapper;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class SaleService : BaseService<Model.Sale, Sale, BaseSearchObject>, ISaleService
    {
        public SaleService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }
    }
}
