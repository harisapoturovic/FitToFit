using AutoMapper;
using FitToFit.Database;
using FitToFit.Model;
using FitToFit.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Rezervacije = FitToFit.Database.Rezervacije;

namespace FitToFit.Services.RezervacijeStateMachine
{
    public class DraftReservationState : BaseState
    {
        public DraftReservationState(IServiceProvider serviceProvider, Ib200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Rezervacije> Update(int id, RezervacijeUpdateRequest request)
        {
            var set = _context.Set<Rezervacije>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<Model.Rezervacije> Activate(int id)
        {
            var set = _context.Set<Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";

            var reservationItems = _context.RezervacijaStavkes.Where(rs => rs.RezervacijaId == id).ToList();

            foreach (var item in reservationItems)
            {
                var termin = await _context.Terminis.FindAsync(item.TerminId);
                if (termin != null)
                {
                    termin.BrojClanova = (byte)(termin.BrojClanova + 1);
                }
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<Model.Rezervacije> Refuse(int id)
        {
            var entity = await _context.Set<Rezervacije>().FindAsync(id);

            var set = _context.Set<Rezervacije>();

            entity.StateMachine = "refused";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");
            list.Add("Refuse");

            return list;
        }
    }
}
