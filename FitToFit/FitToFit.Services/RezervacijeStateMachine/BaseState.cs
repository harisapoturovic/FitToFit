using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using Rezervacije = FitToFit.Services.Database.Rezervacije;

namespace FitToFit.Services.RezervacijeStateMachine
{
    public class BaseState
    {
        protected _200048Context _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }

        public BaseState(IServiceProvider serviceProvider, _200048Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Model.Rezervacije> Insert(Rezervacije entity)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Rezervacije> Update(int id, RezervacijeUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Rezervacije> Activate(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Rezervacije> Archive(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Rezervacije> Refuse(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Rezervacije> Cancel(int id)
        {
            throw new UserException("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialReservationState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftReservationState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveReservationState>();
                    break;
                case "refused":
                    return _serviceProvider.GetService<RefusedReservationState>();
                    break;
                case "canceled":
                    return _serviceProvider.GetService<CanceledReservationState>();
                    break;
                case "archived":
                    return _serviceProvider.GetService<ArchivedReservationState>();
                    break;
            
                default:
                    throw new UserException("Not allowed");
            }
        }
        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }
        
    }
}
