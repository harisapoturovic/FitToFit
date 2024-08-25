using AutoMapper;
using EasyNetQ;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.RezervacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using FitToFit.Services.Database;
using Rezervacije = FitToFit.Services.Database.Rezervacije;
using RezervacijaStavke = FitToFit.Services.Database.RezervacijaStavke;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class RezervacijeService : BaseCRUDService<Model.Rezervacije, Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public BaseState _baseState { get; set; }
        private readonly IMessageProducer _messageProducer;
        public RezervacijeService(BaseState baseState, _200048Context context, IMapper mapper, IMessageProducer messageProducer) : base(context, mapper)
        {
            _baseState = baseState;
            _messageProducer = messageProducer;
        }

        public override IQueryable<Rezervacije> AddInclude(IQueryable<Rezervacije> query, RezervacijeSearchObject search = null)
        {
            if (search?.IsTerminiIncluded == true)
            {
                query = query.Include("RezervacijaStavkes.Termin");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Rezervacije> AddFilter(IQueryable<Rezervacije> query, RezervacijeSearchObject? search = null)
        {
            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId.Equals(search.KorisnikId));
            }

            if (search.ClanarinaId != null)
            {
                query = query.Where(x => x.ClanarinaId.Equals(search.ClanarinaId));
            }

            if(search.TreningId!=null)
            {
                query = query.Where(x => x.RezervacijaStavkes.FirstOrDefault().Termin.TreningId.Equals(search.TreningId));
            }

            if (search?.Datum != null)
            {
                query = query.Where(x => x.Datum.Date.Equals(search.Datum));
            }

            if (search.StateMachine != null)
            {
                query = query.Where(x => x.StateMachine.Equals(search.StateMachine));
            }

            return base.AddFilter(query, search);
        }

        public override Task BeforeInsert(Rezervacije entity, RezervacijeInsertRequest insert)
        {
            entity.RezervacijaStavkes = insert.Items.Select(item => new RezervacijaStavke
            {
                RezervacijaId = entity.RezervacijaId,
                TerminId = item.TerminId,
            }).ToList();

            return base.BeforeInsert(entity, insert);
        }

        public override async Task<Model.Rezervacije> Insert(RezervacijeInsertRequest insert)
        {
            var set = _context.Set<Rezervacije>();

            Rezervacije entity = _mapper.Map<Rezervacije>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            //RabbitMQ: API - objekat - Auxiliary

            var korisnik = entity.Korisnik;
            string clanarina = _context.Clanarines.First(x => x.ClanarinaId == entity.ClanarinaId).Naziv;
            if(korisnik != null && clanarina != null)
            {
                ReservationNotifier reservation = new ReservationNotifier
                {
                    Email = korisnik.Email,
                    Subject= "Nova rezervacija - FitToFit!",
                    Content = $"Poštovani, \n\nZahvaljujemo se što ste se pridružili našem centru! \nOva poruka potvrđuje da je vaša rezervacija za članarinu - {clanarina}, uspješno kreirana. Za sve dodatne informacije ili ako imate bilo kakvih pitanja, slobodno nas kontaktirajte putem ovog emaila. \nRadujemo se što ste dio naše zajednice i nadamo se da ćete uživati u svim pogodnostima koje pružamo. \n\nLijep pozdrav!"
                };
                _messageProducer.SendingObject(reservation);
            }
            
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

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }

        public override async Task<Model.Rezervacije> Delete(int id)
        {
            var reservation = _context.Rezervacijes.Include(r => r.RezervacijaStavkes).FirstOrDefault(r => r.RezervacijaId == id);

            if (reservation != null)
            {
                _context.RezervacijaStavkes.RemoveRange(reservation.RezervacijaStavkes);
                _context.Rezervacijes.Remove(reservation);

                _context.SaveChanges();
            }
            return _mapper.Map<Model.Rezervacije>(reservation);
        }
    }
}
