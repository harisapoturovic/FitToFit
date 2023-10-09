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
    public class RefusedReservationState : BaseState
    {
       public RefusedReservationState(IServiceProvider serviceProvider, Database.Ib200048Context context, IMapper mapper) 
           : base(serviceProvider, context, mapper)
       {
       }

        //public async override Task<Rezervacije> Reactivate(int id)
        //{
        //    var set = _context.Set<Database.Rezervacije>();
        //
        //    var entity = await set.FindAsync(id);
        //
        //    entity.Status = "active";
        //
        //    await _context.SaveChangesAsync();
        //    return _mapper.Map<Model.Rezervacije>(entity);
        //}
    }
}
