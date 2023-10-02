using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class RezervacijaStavke
    {
        public int RezervacijaStavkeId { get; set; }

        public int RezervacijaId { get; set; }

        public int TerminId { get; set; }

        //public virtual Rezervacije Rezervacija { get; set; } = null!;

        public virtual Termini Termin { get; set; } = null!;
    }
}
