﻿using AutoMapper;
using FitToFit.Model;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FitToFit.Services.Database;
using VrsteTreninga = FitToFit.Services.Database.VrsteTreninga;

namespace FitToFit.Services
{
    public class VrsteTreningaService : BaseService<Model.VrsteTreninga, VrsteTreninga, VrsteTreningaSearchObject>, IVrsteTreningaService
    {
        public VrsteTreningaService(_200048Context context, IMapper mapper)
            :base(context, mapper)
        {
        }

        public override IQueryable<VrsteTreninga> AddFilter(IQueryable<VrsteTreninga> query, VrsteTreningaSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Naziv.Contains(search.FTS));
            }

            return base.AddFilter(query, search);
        }
    }
}
  