using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.AkcijeStateMachine;
using FitToFit.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using Vjezbe = FitToFit.Services.Database.Vjezbe;
using Placanja = FitToFit.Services.Database.Placanja;
using System.Runtime.InteropServices;
using Rezervacije = FitToFit.Services.Database.Rezervacije;
using Stripe;

namespace FitToFit.Services
{
    public class PlacanjaService : BaseCRUDService<Model.Placanja, Placanja, PlacanjaSearchObject, PlacanjaInsertRequest, PlacanjaUpdateRequest>, IPlacanjaService
    {
        public PlacanjaService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Placanja> AddFilter(IQueryable<Placanja> query, PlacanjaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.KorisnikId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == search.KorisnikId);
            }

            return filteredQuery;
        }

        public async override Task<Model.Placanja> Insert(PlacanjaInsertRequest insert)
        {
            string? transactionId = null;
            long iznosPlacanja = 0;
            var charges = await getChargesByIntent(insert.PaymentIntentId!);
            foreach (var charge in charges.Data)
            {
                if (charge.Captured)
                {
                    transactionId = charge.BalanceTransactionId;
                    iznosPlacanja = charge.AmountCaptured / 100;
                    break;
                }
            }
            if (transactionId is null)
            {
                throw new Exception("Transkacijski id null");
            }
            var set = _context.Set<Database.Placanja>();
            Database.Placanja entity = _mapper.Map<Database.Placanja>(insert);
            entity.TransactionId = transactionId;
            set.Add(entity);
            List<Rezervacije> mojerezervacijes = _context.Rezervacijes
                .Where(x => x.KorisnikId == insert.KorisnikId && x.StateMachine == "Active").Take((int)iznosPlacanja / 15)
                .ToList();
            foreach (var mojerezervacije in mojerezervacijes)
            {
                //mojerezervacije.StateMachine = "Plaćena";
                mojerezervacije.Placanje = entity;
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Placanja>(entity);
        }

        private async Task<StripeList<Charge>> getChargesByIntent(string paymentIntentId)
        {
            var service = new ChargeService();
            var options = new ChargeListOptions()
            {
                PaymentIntent = paymentIntentId,
            };
            var list = await service.ListAsync(options);
            return list;
        }

    }
}
