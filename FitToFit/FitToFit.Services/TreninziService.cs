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

            return base.AddFilter(query, search);
        }

        public override async Task<Model.Treninzi> Insert(TreninziInsertRequest insert)
        {
            var set = _context.Set<Database.Treninzi>();

            Database.Treninzi entity = _mapper.Map<Database.Treninzi>(insert);

            set.Add(entity);

            await _context.SaveChangesAsync();

            //RabbitMQ: API - poruka - Auxiliary
            //_messageProducer.SendingMessage("\n NOVI TRENING " + "\nID: " + entity.TreningId + "\nNaziv: " + entity.Naziv);

            return _mapper.Map<Model.Treninzi>(entity);
        }
    }
}
