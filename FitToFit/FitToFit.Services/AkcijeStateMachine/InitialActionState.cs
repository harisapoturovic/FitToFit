﻿using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _200048Context = FitToFit.Services.Database._200048Context;
using Akcije = FitToFit.Services.Database.Akcije;

namespace FitToFit.Services.AkcijeStateMachine
{
    public class InitialActionState : AkcijeBaseState
    {
        public InitialActionState(IServiceProvider serviceProvider, _200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Akcije> Insert(Akcije entity)
        {
            entity.StateMachine = "draft";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Akcije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
