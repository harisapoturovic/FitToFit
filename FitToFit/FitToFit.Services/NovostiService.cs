using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace FitToFit.Services
{
    public class NovostiService : BaseCRUDService<Model.Novosti, Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>, INovostiService
    {
        public NovostiService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        private List<int> GetActiveVrstaTreningaIds(int korisnikId)
        {
            var treningIds = _context.Rezervacijes
                .Where(r => r.KorisnikId == korisnikId && r.StateMachine == "active")
                .SelectMany(r => r.RezervacijaStavkes)
                .Select(rs => rs.Termin.TreningId)
                .Distinct()
                .ToList();

            var vrstaTreningaIds = _context.Treninzis
                .Where(t => treningIds.Contains(t.TreningId))
                .Select(t => t.VrstaId)
                .Distinct()
                .ToList();

            return vrstaTreningaIds;
        }

        public override IQueryable<Novosti> AddFilter(IQueryable<Novosti> query, NovostiSearchObject? search = null)
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
            if (search.KorisnikId != null)
            {
                var korisnikId = search.KorisnikId.Value;

                var activeVrstaTreningaIds = GetActiveVrstaTreningaIds(korisnikId);

                if (activeVrstaTreningaIds.IsNullOrEmpty())
                {
                    query = query.Where(x => x.VrstaTreningaId == null);
                }
                else
                {
                    query = query.Where(x => activeVrstaTreningaIds.Contains(x.VrstaTreningaId ?? 0) || x.VrstaTreningaId == null);
                }
            }
            query = query.OrderByDescending(x => x.DatumObjave);
            return base.AddFilter(query, search);
        }

        public virtual async Task<Model.Novosti> Insert(NovostiInsertRequest insert)
        {
            var set = _context.Set<Novosti>();

            Novosti entity = _mapper.Map<Novosti>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            var korisnici = _context.Set<Korisnici>();
            var korisniciNovosti = _context.Set<KorisniciNovosti>();
            foreach (var item in korisnici)
            {
                KorisniciNovosti n = new KorisniciNovosti();
                n.KorisnikId = item.KorisnikId;
                n.NovostId = entity.NovostId;

                korisniciNovosti.Add(n);
            }
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Novosti>(entity);
        }
    }
}
