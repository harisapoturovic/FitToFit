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
    public class ClanarineService : BaseService<Model.Clanarine, Database.Clanarine, ClanarineSearchObject>, IClanarineService
    {
        public ClanarineService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }
        public override IQueryable<Database.Clanarine> AddFilter(IQueryable<Database.Clanarine> query, ClanarineSearchObject? search = null)
        {
            if (search.ClanarinaId != null)
            {
                query = query.Where(x => x.ClanarinaId.Equals(search.ClanarinaId));
            }

            return base.AddFilter(query, search);
        }

    }
}
