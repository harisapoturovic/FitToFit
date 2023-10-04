using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
using FitToFit.Services.RezervacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace FitToFit.Services
{
    public class RezervacijeService : BaseCRUDService<Model.Rezervacije, Database.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public BaseState _baseState { get; set; }
        public RezervacijeService(BaseState baseState, Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState; 
        }

        public override IQueryable<Database.Rezervacije> AddInclude(IQueryable<Database.Rezervacije> query, RezervacijeSearchObject search = null)
        {
            if (search?.IsTerminiIncluded == true)
            {
                query = query.Include("RezervacijaStavkes.Termin");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.Rezervacije> AddFilter(IQueryable<Database.Rezervacije> query, RezervacijeSearchObject? search = null)
        {
            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId.Equals(search.KorisnikId));
            }

            if (search.ClanarinaId != null)
            {
                query = query.Where(x => x.ClanarinaId.Equals(search.ClanarinaId));
            }

            if (search?.Datum != null)
            {
                query = query.Where(x => x.Datum.Equals(search.Datum));
            }

            return base.AddFilter(query, search);
        }

        public override Task BeforeInsert(Database.Rezervacije entity, RezervacijeInsertRequest insert)
        {
            entity.RezervacijaStavkes = insert.Items.Select(item => new Database.RezervacijaStavke
            {
                RezervacijaId = entity.RezervacijaId,
                TerminId = item.TerminId,
            }).ToList();

            return base.BeforeInsert(entity, insert);
        }

        public override async Task<Model.Rezervacije> Insert(RezervacijeInsertRequest insert)
        {
            var set = _context.Set<Database.Rezervacije>();

            Database.Rezervacije entity = _mapper.Map<Database.Rezervacije>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            var state = _baseState.CreateState("initial");
            return await state.Insert(entity);
        }

        public override async Task<Model.Rezervacije> Update(int id, RezervacijeUpdateRequest update)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }

        public async Task<Model.Rezervacije> Activate(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Model.Rezervacije> Refuse(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Refuse(id);
        }

        public async Task<Model.Rezervacije> Cancel(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Cancel(id);
        }

        public async Task<Model.Rezervacije> Archive(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Archive(id);
        }

        //public async Task<Model.Rezervacije> Reactivate(int id)
        //{
        //    var entity = await _context.Rezervacijes.FindAsync(id);
        //
        //    var state = _baseState.CreateState(entity.Status);
        //
        //    return await state.Reactivate(id);
        //}

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }
    }
}
