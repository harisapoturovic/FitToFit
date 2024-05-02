using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.AkcijeStateMachine;
using FitToFit.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class VjezbeTreninziService : BaseService<Model.TreninziVjezbe, Database.TreninziVjezbe, BaseSearchObject>, IVjezbeTreninziService
    {
        public VjezbeTreninziService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task<Model.TreninziVjezbe> Insert(VjezbeTreninziInsertRequest insert)
        {
            var set = _context.Set<Database.TreninziVjezbe>();

            Database.TreninziVjezbe entity = _mapper.Map<Database.TreninziVjezbe>(insert);

            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.TreninziVjezbe>(entity);
        }

        public virtual async Task<Model.TreninziVjezbe> Delete(int id)
        {
            var set = _context.Set<Database.TreninziVjezbe>();

            var entity = await set.FindAsync(id);

            set.Remove(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.TreninziVjezbe>(entity);
        }
    }
}
