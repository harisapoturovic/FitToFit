﻿using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services.AkcijeStateMachine
{
    public class ActiveActionState : AkcijeBaseState
    {
        public ActiveActionState(IServiceProvider serviceProvider, Database.Ib200048Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Akcije> Archive(int id)
        {
            var set = _context.Set<Database.Akcije>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "archived";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Akcije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Archive");

            return list;
        }
    }
}
