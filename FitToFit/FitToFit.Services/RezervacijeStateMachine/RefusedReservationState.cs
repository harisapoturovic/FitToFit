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

namespace FitToFit.Services.RezervacijeStateMachine
{
    public class RefusedReservationState : BaseState
    {
       public RefusedReservationState(IServiceProvider serviceProvider, _200048Context context, IMapper mapper) 
           : base(serviceProvider, context, mapper)
       {
       }
    }
}
