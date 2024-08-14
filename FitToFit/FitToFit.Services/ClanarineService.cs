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
    public class ClanarineService : BaseService<Model.Clanarine, Clanarine, ClanarineSearchObject>, IClanarineService
    {
        public ClanarineService(_200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }
        public override IQueryable<Clanarine> AddFilter(IQueryable<Clanarine> query, ClanarineSearchObject? search = null)
        {
            if (search.ClanarinaId != null)
            {
                query = query.Where(x => x.ClanarinaId.Equals(search.ClanarinaId));
            }

            return base.AddFilter(query, search);
        }

    }
}
