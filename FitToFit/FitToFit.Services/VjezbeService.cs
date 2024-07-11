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

namespace FitToFit.Services
{
    public class VjezbeService : BaseCRUDService<Model.Vjezbe, Database.Vjezbe, VjezbeSearchObject, VjezbeInsertRequest, VjezbeUpdateRequest>, IVjezbeService
    {
        public VjezbeService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Vjezbe> AddFilter(IQueryable<Database.Vjezbe> query, VjezbeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            return base.AddFilter(query, search);
        }    

        public override async Task<Model.Vjezbe> Delete(int id)
        {
            var vjezba = _context.Vjezbes.Include(r => r.TreninziVjezbes).FirstOrDefault(r => r.VjezbaId == id);

            if (vjezba != null)
            {
                _context.TreninziVjezbes.RemoveRange(vjezba.TreninziVjezbes);
                _context.Vjezbes.Remove(vjezba);

                _context.SaveChanges();
            }
            return _mapper.Map<Model.Vjezbe>(vjezba);
        }
    }
}
