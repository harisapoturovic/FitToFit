using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class TreninziService : BaseCRUDService<Model.Treninzi, Database.Treninzi, TreninziSearchObject, TreninziInsertRequest, TreninziUpdateRequest>, ITreninziService
    {
        public TreninziService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Treninzi> AddInclude(IQueryable<Database.Treninzi> query, TreninziSearchObject search = null)
        {
            if (search?.IsTerminiIncluded == true)
            {
                query = query.Include("Terminis");
            }
            if (search?.IsVjezbeIncluded == true)
            {
                query = query.Include("TreninziVjezbes.Vjezba");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.Treninzi> AddFilter(IQueryable<Database.Treninzi> query, TreninziSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            return base.AddFilter(query, search);
        }
    }
}
