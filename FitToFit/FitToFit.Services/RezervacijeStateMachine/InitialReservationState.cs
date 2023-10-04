using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services.RezervacijeStateMachine
{
    public class InitialReservationState : BaseState
    {
        public InitialReservationState(IServiceProvider serviceProvider, Database.Ib200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Rezervacije> Insert(Database.Rezervacije entity)
        {
            entity.StateMachine = "draft";

            _context.SaveChangesAsync();
            return _mapper.Map<Rezervacije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
