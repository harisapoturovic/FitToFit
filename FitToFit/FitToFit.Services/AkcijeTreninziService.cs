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
using AkcijeTreninzi = FitToFit.Database.AkcijeTreninzi;

namespace FitToFit.Services
{
    public class AkcijeTreninziService : BaseService<Model.AkcijeTreninzi, AkcijeTreninzi, BaseSearchObject>, IAkcijeTreninziService
    {
        public AkcijeTreninziService(Ib200048Context context, IMapper mapper) : base(context, mapper)
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
    }
}
