using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class AkcijeService : BaseCRUDService<Model.Akcije, Database.Akcije, AkcijeSearchObject, AkcijeInsertRequest, AkcijeUpdateRequest>, IAkcijeService
    {
        public AkcijeService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Akcije> AddInclude(IQueryable<Database.Akcije> query, AkcijeSearchObject search = null)
        {
            if (search?.IsTreninziIncluded == true)
            {
                query = query.Include("AkcijeTreninzis.Trening");
            }
             
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.Akcije> AddFilter(IQueryable<Database.Akcije> query, AkcijeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.Contains(search.Naziv));
            }

            if (search?.DatumPocetka != null)
            {
                query = query.Where(x => x.DatumPocetka.Equals(search.DatumPocetka));
            }

            //foreach (var i in query)
            //{
            //    if(i.DatumZavrsetka.CompareTo(DateTime.Now)>0)
            //    {
            //        return null; //arhivirana
            //    }            
            //}

            return base.AddFilter(query, search);
        }

        public override Task BeforeInsert(Database.Akcije entity, AkcijeInsertRequest insert)
        {
            entity.AkcijeTreninzis = insert.Items.Select(item => new Database.AkcijeTreninzi
            {
                AkcijaId = entity.AkcijaId,
                TreningId = item.TreningId,
            }).ToList();
            return base.BeforeInsert(entity, insert);
        }
        /*
        public override async Task<Model.Akcije> Delete(int id)
        {
            
            //var set = await _context.AkcijeTreninzis.Where(x => x.AkcijaId == id).ToListAsync();
            //foreach (var item in set)
            //{
            //    set.Remove(item);
            //}
            
            
            var set = await _context.AkcijeTreninzis.ToListAsync();
            for (int i = 0; i < set.Count; i++)
            {
                var item = set.FirstOrDefault(x=>x.AkcijaId==id);

                if(item!=null)
                {
                    set.Remove(item);
                    continue;
                }
            }

            return await base.Delete(id);
        }*/
    }
}
