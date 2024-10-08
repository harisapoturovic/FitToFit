﻿using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using TreninziClanarine = FitToFit.Services.Database.TreninziClanarine;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class TreninziClanarineService : BaseCRUDService<Model.TreninziClanarine, TreninziClanarine, TreninziClanarineSearchObject, TreninziClanarineInsertRequest, TreninziClanarineUpdateRequest>, ITreninziClanarine
    {
        public TreninziClanarineService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<TreninziClanarine> AddFilter(IQueryable<TreninziClanarine> query, TreninziClanarineSearchObject? search = null)
        {
            if (search.Cijena != null)
            {
                query = query.Where(x => x.Cijena.Equals(search.Cijena));
            }

            if (search.Ucestalost != null)
            {
                query = query.Where(x => x.Ucestalost.Equals(search.Ucestalost));
            }

            if (search.VrstaTreningaId != null)
            {
                query = query.Where(x => x.VrstaTreningaId.Equals(search.VrstaTreningaId));
            }

            if (search.ClanarinaId != null)
            {
                query = query.Where(x => x.ClanarinaId.Equals(search.ClanarinaId));
            }

            if (!string.IsNullOrWhiteSpace(search?.VrstaTreningaNaziv))
            {
                query = query.Where(x => x.VrstaTreninga.Naziv.Equals(search.VrstaTreningaNaziv));
            }


            return base.AddFilter(query, search);
        }
    }
}
