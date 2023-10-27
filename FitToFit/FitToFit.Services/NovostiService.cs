using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class NovostiService : BaseCRUDService<Model.Novosti, Database.Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>, INovostiService
    {
        public NovostiService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<Database.Novosti> AddFilter(IQueryable<Database.Novosti> query, NovostiSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naslov))
            {
                query = query.Where(x => x.Naslov.StartsWith(search.Naslov));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Naslov.Contains(search.FTS));
            }
            if (search.VrstaTreningaId != null)
            {
                query = query.Where(x => x.VrstaTreningaId.Equals(search.VrstaTreningaId));
            }

            return base.AddFilter(query, search);
        }
    }
}
