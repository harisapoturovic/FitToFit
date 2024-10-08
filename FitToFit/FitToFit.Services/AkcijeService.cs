﻿using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.AkcijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using Akcije = FitToFit.Services.Database.Akcije;
using AkcijeTreninzi = FitToFit.Services.Database.AkcijeTreninzi;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class AkcijeService : BaseCRUDService<Model.Akcije, Akcije, AkcijeSearchObject, AkcijeInsertRequest, AkcijeUpdateRequest>, IAkcijeService
    {
        public AkcijeBaseState _baseState { get; set; }
        public AkcijeService(AkcijeBaseState baseState, _200048Context context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public override IQueryable<Akcije> AddInclude(IQueryable<Akcije> query, AkcijeSearchObject search = null)
        {
            if (search?.IsTreninziIncluded == true)
            {
                query = query.Include("AkcijeTreninzis.Trening");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Akcije> AddFilter(IQueryable<Akcije> query, AkcijeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if (search?.DatumPocetka != null)
            {
                query = query.Where(x => x.DatumPocetka.Date.Equals(search.DatumPocetka));
            }

            if (!string.IsNullOrWhiteSpace(search?.StateMachine))
            {
                query = query.Where(x => x.StateMachine.Contains(search.StateMachine));
            }

            if (search?.TreningId != null)
            {
                query = query.Where(a => a.AkcijeTreninzis.Any(at => at.TreningId == search.TreningId));
            }

            return base.AddFilter(query, search);
        }

        public override Task BeforeInsert(Akcije entity, AkcijeInsertRequest insert)
        {
            entity.AkcijeTreninzis = insert.Items.Select(item => new AkcijeTreninzi
            {
                AkcijaId = entity.AkcijaId,
                TreningId = item.TreningId,
            }).ToList();
            return base.BeforeInsert(entity, insert);
        }

        public override async Task<Model.Akcije> Insert(AkcijeInsertRequest insert)
        {
            var set = _context.Set<Akcije>();

            Akcije entity = _mapper.Map<Akcije>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            var state = _baseState.CreateState("initial");
            return await state.Insert(entity);
        }

        public override async Task<Model.Akcije> Update(int id, AkcijeUpdateRequest update)
        {
            var entity = await _context.Akcijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }

        public async Task<Model.Akcije> Activate(int id)
        {
            var entity = await _context.Akcijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Model.Akcije> Archive(int id)
        {
            var entity = await _context.Akcijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Archive(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Akcijes.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }

        public override async Task<Model.Akcije> Delete(int id)
        {
            var action = _context.Akcijes.Include(r => r.AkcijeTreninzis).FirstOrDefault(r => r.AkcijaId == id);

            if (action != null)
            {
                _context.AkcijeTreninzis.RemoveRange(action.AkcijeTreninzis);
                _context.Akcijes.Remove(action);

                _context.SaveChanges();
            }
            return _mapper.Map<Model.Akcije>(action);
        }

        public async Task<List<Model.Akcije>> GetAkcijeForTrening(int treningId)
        {
            var akcijeQuery = _context.Akcijes
                                    .Where(a => a.AkcijeTreninzis.Any(at => at.TreningId == treningId && at.Akcija.StateMachine=="active"))
                                    .Include(a => a.AkcijeTreninzis);

            var akcijeList = await akcijeQuery.ToListAsync();

            return _mapper.Map<List<Model.Akcije>>(akcijeList);
        }

    }
}
