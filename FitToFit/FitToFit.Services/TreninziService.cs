using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using FitToFit.Services.RezervacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;

namespace FitToFit.Services
{
    public class TreninziService : BaseCRUDService<Model.Treninzi, Database.Treninzi, TreninziSearchObject, TreninziInsertRequest, TreninziUpdateRequest>, ITreninziService
    {
        private readonly IMessageProducer _messageProducer;
        public TreninziService(Ib200048Context context, IMapper mapper, IMessageProducer messageProducer) : base(context, mapper)
        {
            _messageProducer = messageProducer;
        }

        public override IQueryable<Database.Treninzi> AddInclude(IQueryable<Database.Treninzi> query, TreninziSearchObject search = null)
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

        public override IQueryable<Database.Treninzi> AddFilter(IQueryable<Database.Treninzi> query, TreninziSearchObject? search = null)
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


        public override Task BeforeInsert(Database.Treninzi entity, TreninziInsertRequest insert)
        {
            entity.TreninziVjezbes = insert.Items.Select(item => new Database.TreninziVjezbe
            {
                TreningId = entity.TreningId,
                VjezbaId = item.VjezbaId,
                Trajanje=item.Trajanje
            }).ToList();
            return base.BeforeInsert(entity, insert);
        }

        public override async Task<Model.Treninzi> Insert(TreninziInsertRequest insert)
        {
            var set = _context.Set<Database.Treninzi>();

            Database.Treninzi entity = _mapper.Map<Database.Treninzi>(insert);

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
            var set = _context.Set<Database.Treninzi>();
            var vjezebTreninziSet = _context.Set<Database.TreninziVjezbe>();

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
