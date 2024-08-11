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
    }
}
