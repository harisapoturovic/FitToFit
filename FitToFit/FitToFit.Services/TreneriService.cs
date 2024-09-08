using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class TreneriService : BaseCRUDService<Model.Treneri, Treneri, TreneriSearchObject, TreneriInsertRequest, TreneriUpdateRequest>, ITreneriService
    {
        public TreneriService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Treneri> AddInclude(IQueryable<Treneri> query, TreneriSearchObject? search = null)
        {
            if (search?.IsOcjeneIncluded == true)
            {
                query = query.Include("Ocjenes");
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Treneri> AddFilter(IQueryable<Treneri> query, TreneriSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search.Ime))
            {
                filteredQuery = filteredQuery.Where(x => x.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search.Prezime))
            {
                filteredQuery = filteredQuery.Where(x => x.Prezime.Contains(search.Prezime));
            }

            return filteredQuery;
        }

        public virtual async Task<Model.Treneri> Delete(int id)
        {
            var set = _context.Set<Treneri>();
            var ocjeneSet = _context.Set<Ocjene>();
            var terminiSet = _context.Set<Termini>();
            var rezervacijaStavkeSet = _context.Set<RezervacijaStavke>();

            var trener = await set.FirstOrDefaultAsync(n => n.TrenerId == id);

            if (trener == null)
            {
                throw new InvalidOperationException("Trener nije pronađen");
            }

            var ocjeneList = await ocjeneSet
                .Where(kn => kn.TrenerId == id)
                .ToListAsync();

            var terminiList = await terminiSet
                .Where(kn => kn.TrenerId == id)
                .ToListAsync();

            ocjeneSet.RemoveRange(ocjeneList);
            var terminiIds = terminiList.Select(r => r.TerminId).ToList();

            var rezervacijaStavkeList = await rezervacijaStavkeSet
                .Where(rs => terminiIds.Contains(rs.TerminId))
                .ToListAsync();

            rezervacijaStavkeSet.RemoveRange(rezervacijaStavkeList);
            terminiSet.RemoveRange(terminiList);

            set.Remove(trener);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Treneri>(trener);
        }
    }
}
