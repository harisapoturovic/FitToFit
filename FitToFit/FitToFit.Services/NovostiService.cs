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
    public class NovostiService : BaseCRUDService<Model.Novosti, Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>, INovostiService
    {
        public NovostiService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
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
