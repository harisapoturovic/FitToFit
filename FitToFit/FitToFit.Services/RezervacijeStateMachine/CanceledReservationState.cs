using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services.RezervacijeStateMachine
{
    public class CanceledReservationState : BaseState
    {
        public CanceledReservationState(IServiceProvider serviceProvider, _200048Context context, IMapper mapper)
            : base(serviceProvider, context, mapper)
        {
        }
    }
}
