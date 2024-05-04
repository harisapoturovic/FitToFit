﻿using AutoMapper;
using FitToFit.Model;
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
    public class RezervacijaStavkeService : BaseService<Model.RezervacijaStavke, Database.RezervacijaStavke, BaseSearchObject>, IRezervacijaStavkeService
    {
        public RezervacijaStavkeService(Ib200048Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public virtual async Task<List<Model.OdabraniTermini>> GetTop3Terms(string? order=null)
        {
            var query = _context.Set<Database.RezervacijaStavke>().AsQueryable();
            var list = await query.ToListAsync();
            List<Database.RezervacijaStavke> top3Terms;

            if (order == "desc")
            {
                top3Terms = list
                    .GroupBy(r => r.TerminId)
                    .OrderByDescending(g => g.Count())
                    .Take(3)
                    .SelectMany(g => g)
                    .ToList();
            }
            else
            {
                top3Terms = list
                    .GroupBy(r => r.TerminId)
                    .OrderBy(g => g.Count())
                    .Take(3)
                    .SelectMany(g => g)
                    .ToList();
            }
            var query2 = _context.Set<Database.Termini>().AsQueryable();
            var termini = await query2.ToListAsync();
            var top3Termini = termini.Where(t => top3Terms.Select(tt => tt.TerminId).Contains(t.TerminId));

            var odabraniTerminiList = new List<OdabraniTermini>();
            foreach (var termin in top3Termini)
            {
                var count = top3Terms.Count(tt => tt.TerminId == termin.TerminId);

                var trening = await _context.Set<Database.Treninzi>().FindAsync(termin.TreningId);
                if (trening != null)
                {
                    var opis = $"{termin.Dan} {termin.Sat} - {trening.Naziv}"; 
                    odabraniTerminiList.Add(new OdabraniTermini { Opis = opis, Count = count });
                }
            }

            return odabraniTerminiList;
        }
    }
}
