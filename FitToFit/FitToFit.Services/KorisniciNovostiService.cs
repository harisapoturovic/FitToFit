using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.AkcijeStateMachine;
using FitToFit.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using KorisniciNovosti = FitToFit.Services.Database.KorisniciNovosti;

namespace FitToFit.Services
{
    public class KorisniciNovostiService : BaseCRUDService<Model.KorisniciNovosti, KorisniciNovosti, KorisniciNovostiSearchObject, KorisniciNovostiInsertRequest, KorisniciNovostiInsertRequest>, IKorisniciNovostiService
    {
        public KorisniciNovostiService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<KorisniciNovosti> AddFilter(IQueryable<KorisniciNovosti> query, KorisniciNovostiSearchObject? search = null)
        {
            if (search.korisnikId != null)
            {
                query = query.Where(x => x.KorisnikId.Equals(search.korisnikId));
            }

            if (search.novostId != null)
            {
                query = query.Where(x => x.NovostId.Equals(search.novostId));
            }

            return base.AddFilter(query, search);
        }      

    }
}
