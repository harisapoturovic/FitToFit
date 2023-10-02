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
    public class RezervacijeService : BaseCRUDService<Model.Rezervacije, Database.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public RezervacijeService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Rezervacije> AddInclude(IQueryable<Database.Rezervacije> query, RezervacijeSearchObject search = null)
        {
            if (search?.IsTerminiIncluded == true)
            {
                query = query.Include("RezervacijaStavkes.Termin");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.Rezervacije> AddFilter(IQueryable<Database.Rezervacije> query, RezervacijeSearchObject? search = null)
        {
            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId.Equals(search.KorisnikId));
            }

            if (search.ClanarinaId != null)
            {
                query = query.Where(x => x.ClanarinaId.Equals(search.ClanarinaId));
            }

            if (search?.Datum != null)
            {
                query = query.Where(x => x.Datum.Equals(search.Datum));
            }

            return base.AddFilter(query, search);
        }

        public override Task BeforeInsert(Database.Rezervacije entity, RezervacijeInsertRequest insert)
        {
            entity.RezervacijaStavkes = insert.Items.Select(item => new Database.RezervacijaStavke
            {
                RezervacijaId = entity.RezervacijaId,
                TerminId = item.TerminId,
            }).ToList();

            return base.BeforeInsert(entity, insert);
        }
    }
}
