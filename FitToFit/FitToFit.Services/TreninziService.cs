using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.RezervacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;
using FitToFit.Services.Database;
using Treninzi = FitToFit.Services.Database.Treninzi;
using TreninziVjezbe = FitToFit.Services.Database.TreninziVjezbe;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class TreninziService : BaseCRUDService<Model.Treninzi, Treninzi, TreninziSearchObject, TreninziInsertRequest, TreninziUpdateRequest>, ITreninziService
    {
        private readonly IMessageProducer _messageProducer;
        public TreninziService(_200048Context context, IMapper mapper, IMessageProducer messageProducer) : base(context, mapper)
        {
            _messageProducer = messageProducer;
        }

        public override IQueryable<Treninzi> AddInclude(IQueryable<Treninzi> query, TreninziSearchObject search = null)
        {
            if (search?.IsTerminiIncluded == true)
            {
                query = query.Include("Terminis");
            }
            if (search?.IsVjezbeIncluded == true)
            {
                query = query.Include("TreninziVjezbes.Vjezba");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Treninzi> AddFilter(IQueryable<Treninzi> query, TreninziSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if (search?.VrstaTreninga != null)
            {
                query = query.Where(x => x.Vrsta.VrstaTreningaId.Equals(search.VrstaTreninga));
            }

            if (!string.IsNullOrWhiteSpace(search?.VrstaTreningaNaziv))
            {
                query = query.Where(x => x.Vrsta.Naziv.Equals(search.VrstaTreningaNaziv));
            }

            if (!string.IsNullOrWhiteSpace(search?.Namjena))
            {
                query = query.Where(x => x.Namjena.Equals(search.Namjena));
            }

            if (search?.TreningId != null)
            {
                query = query.Where(x => x.TreningId.Equals(search.TreningId));
            }

            return base.AddFilter(query, search);
        }


        public override Task BeforeInsert(Treninzi entity, TreninziInsertRequest insert)
        {
            entity.TreninziVjezbes = insert.Items.Select(item => new TreninziVjezbe
            {
                TreningId = entity.TreningId,
                VjezbaId = item.VjezbaId,
                Trajanje=item.Trajanje
            }).ToList();
            return base.BeforeInsert(entity, insert);
        }

        public override async Task<Model.Treninzi> Insert(TreninziInsertRequest insert)
        {
            var set = _context.Set<Treninzi>();

            Treninzi entity = _mapper.Map<Treninzi>(insert);

            set.Add(entity);
            if(!insert.Items.IsNullOrEmpty())
                await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            //RabbitMQ: API - poruka - Auxiliary
            //_messageProducer.SendingMessage("\n NOVI TRENING " + "\nID: " + entity.TreningId + "\nNaziv: " + entity.Naziv);

            return _mapper.Map<Model.Treninzi>(entity);
        }

        public virtual async Task<Model.Treninzi> Delete(int id)
        {
            var set = _context.Set<Treninzi>();
            var vjezebTreninziSet = _context.Set<TreninziVjezbe>();

            var trening = await set.FirstOrDefaultAsync(n => n.TreningId == id);

            if (trening == null)
            {
                throw new InvalidOperationException("Trening nije pronađen");
            }

            var vjezebTreninziList = await vjezebTreninziSet
                .Where(kn => kn.TreningId == id)
                .ToListAsync();

            vjezebTreninziSet.RemoveRange(vjezebTreninziList);

            set.Remove(trening);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Treninzi>(trening);
        }
    }
}
