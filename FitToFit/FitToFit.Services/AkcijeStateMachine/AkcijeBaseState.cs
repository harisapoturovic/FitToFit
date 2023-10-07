using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services.AkcijeStateMachine
{
    public class AkcijeBaseState
    {
        protected Ib200048Context _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }

        public AkcijeBaseState(IServiceProvider serviceProvider, Ib200048Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Model.Akcije> Insert(Database.Akcije entity)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Akcije> Update(int id, AkcijeUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Akcije> Activate(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Akcije> Archive(int id)
        {
            throw new UserException("Not allowed");
        }

        public AkcijeBaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialActionState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftActionState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveActionState>();
                    break;
                case "archived":
                    return _serviceProvider.GetService<ArchivedActionState>();
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
