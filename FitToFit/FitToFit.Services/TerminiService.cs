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
    public class TerminiService : BaseCRUDService<Model.Termini, Database.Termini, TerminiSearchObject, TerminiInsertRequest, TerminiUpdateRequest>, ITerminiService
    {
        public TerminiService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Termini> AddFilter(IQueryable<Database.Termini> query, TerminiSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Dan))
            {
                query = query.Where(x => x.Dan.Equals(search.Dan));
            }

            if (!string.IsNullOrWhiteSpace(search?.Sat))
            {
                query = query.Where(x => x.Sat.Equals(search.Sat));
            }

            if (search.TrenerId != null)
            {
                query = query.Where(x => x.TrenerId.Equals(search.TrenerId));
            }

            if (search.TreningId != null)
            {
                query = query.Where(x => x.TreningId.Equals(search.TreningId));
            }

            if (search.SalaId != null)
            {
                query = query.Where(x => x.SalaId.Equals(search.SalaId));
            }
            return base.AddFilter(query, search);
        }
    }
}
