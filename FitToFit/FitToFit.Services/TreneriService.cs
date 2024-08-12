using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class TreneriService : BaseCRUDService<Model.Treneri, Treneri, TreneriSearchObject, TreneriInsertRequest, TreneriUpdateRequest>, ITreneriService
    {
        public TreneriService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Treneri> AddInclude(IQueryable<Treneri> query, TreneriSearchObject? search = null)
        {
            if (search?.IsOcjeneIncluded == true)
            {
                query = query.Include("Ocjenes");
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Treneri> AddFilter(IQueryable<Treneri> query, TreneriSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search.Ime))
            {
                filteredQuery = filteredQuery.Where(x => x.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search.Prezime))
            {
                filteredQuery = filteredQuery.Where(x => x.Prezime.Contains(search.Prezime));
            }

            return filteredQuery;
        }
    }
}
