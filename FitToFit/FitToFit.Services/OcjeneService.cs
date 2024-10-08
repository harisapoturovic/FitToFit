﻿using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class OcjeneService : BaseCRUDService<Model.Ocjene, Ocjene, OcjeneSearchObject, OcjeneInsertRequest, OcjeneInsertRequest>, IOcjeneService
    {
        public OcjeneService(_200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<Ocjene> AddFilter(IQueryable<Ocjene> query, OcjeneSearchObject? search = null)
        {
            if (search.TrenerId != null)
            {
                query = query.Where(x => x.TrenerId.Equals(search.TrenerId));
            }

            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId.Equals(search.KorisnikId));
            }

            return base.AddFilter(query, search);
        }
    }
}
