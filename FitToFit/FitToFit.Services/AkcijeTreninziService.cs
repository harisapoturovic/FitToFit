using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.AkcijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using AkcijeTreninzi = FitToFit.Services.Database.AkcijeTreninzi;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class AkcijeTreninziService : BaseService<Model.AkcijeTreninzi, AkcijeTreninzi, AkcijeTreninziSearchObject>, IAkcijeTreninziService
    {
        public AkcijeTreninziService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task<Model.AkcijeTreninzi> Insert(AkcijeTreninziInsertRequest insert)
        {
            var set = _context.Set<AkcijeTreninzi>();

            AkcijeTreninzi entity = _mapper.Map<AkcijeTreninzi>(insert);

            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.AkcijeTreninzi>(entity);
        }

        public virtual async Task<Model.AkcijeTreninzi> Delete(int id)
        {
            var set = _context.Set<AkcijeTreninzi>();

            var entity = await set.FindAsync(id);

            set.Remove(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.AkcijeTreninzi>(entity);
        }

        public override IQueryable<AkcijeTreninzi> AddFilter(IQueryable<AkcijeTreninzi> query, AkcijeTreninziSearchObject? search = null)
        {
            
            if (search?.AkcijaId != null)
            {
                query = query.Where(a => a.AkcijaId==search.AkcijaId);
            }

            return base.AddFilter(query, search);
        }
    }
}
