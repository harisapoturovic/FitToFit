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
using Termini = FitToFit.Services.Database.Termini;
using _200048Context = FitToFit.Services.Database._200048Context;

namespace FitToFit.Services
{
    public class TerminiService : BaseCRUDService<Model.Termini, Termini, TerminiSearchObject, TerminiInsertRequest, TerminiUpdateRequest>, ITerminiService
    {
        public TerminiService(_200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Termini> AddFilter(IQueryable<Termini> query, TerminiSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Dan))
            {
                query = query.Where(x => x.Dan.Equals(search.Dan));
            }

            if (search?.Sat != null)
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

            if (!string.IsNullOrWhiteSpace(search?.NazivTreninga))
            {
                query = query.Where(x => x.Trening.Naziv.Equals(search.NazivTreninga));
            }

            if (search.TerminId != null)
            {
                query = query.Where(x => x.TerminId.Equals(search.TerminId));
            }

            return base.AddFilter(query, search);
        }
    }
}
