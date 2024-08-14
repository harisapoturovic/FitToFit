using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using Rezervacije = FitToFit.Services.Database.Rezervacije;

namespace FitToFit.Services.RezervacijeStateMachine
{
    public class ActiveReservationState : BaseState
    {
        public ActiveReservationState(IServiceProvider serviceProvider, _200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Rezervacije> Cancel(int id)
        {
            var set = _context.Set<Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "canceled";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<Model.Rezervacije> Archive(int id)
        {
            var set = _context.Set<Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "archived";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Cancel");
            list.Add("Archive");

            return list;
        }
    }
}
