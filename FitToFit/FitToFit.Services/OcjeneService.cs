using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class OcjeneService : BaseCRUDService<Model.Ocjene, Ocjene, OcjeneSearchObject, OcjeneInsertRequest, OcjeneInsertRequest>, IOcjeneService
    {
        public OcjeneService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<Ocjene> AddFilter(IQueryable<Ocjene> query, OcjeneSearchObject? search = null)
        {
            if (search.TrenerId != null)
            {
                query = query.Where(x => x.TrenerId.Equals(search.TrenerId));
            }

            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId.Equals(search.KorisnikId));
            }

            return base.AddFilter(query, search);
        }
    }
}
