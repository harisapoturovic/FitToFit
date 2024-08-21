using AutoMapper;
using FitToFit.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using _200048Context = FitToFit.Services.Database._200048Context;

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
