using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services.AkcijeStateMachine
{
    public class InitialActionState : AkcijeBaseState
    {
        public InitialActionState(IServiceProvider serviceProvider, Database.Ib200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Akcije> Insert(Database.Akcije entity)
        {
            entity.StateMachine = "draft";

            await _context.SaveChangesAsync();
            return _mapper.Map<Akcije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
