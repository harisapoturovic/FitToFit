using AutoMapper;
using FitToFit.Database;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Akcije = FitToFit.Services.Database.Akcije;

namespace FitToFit.Services.AkcijeStateMachine
{
    public class DraftActionState : AkcijeBaseState
    {
        public DraftActionState(IServiceProvider serviceProvider, _200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Akcije> Update(int id, AkcijeUpdateRequest request)
        {
            var set = _context.Set<Akcije>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            entity.StateMachine = "draft";

            if (entity.DatumZavrsetka<entity.DatumPocetka)
            {
                throw new UserException("Nedozvoljeno");
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Akcije>(entity);
        }

        public override async Task<Model.Akcije> Activate(int id)
        {
            var set = _context.Set<Akcije>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Akcije>(entity);
        }
             

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");

            return list;
        }
    }
}
