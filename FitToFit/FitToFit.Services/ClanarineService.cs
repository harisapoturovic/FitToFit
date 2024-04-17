using AutoMapper;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class ClanarineService : BaseService<Model.Clanarine, Database.Clanarine, BaseSearchObject>, IClanarineService
    {
        public ClanarineService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }
    }
}
