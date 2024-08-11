using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Ocjene
    {
        public int OcjenaId { get; set; }

        public DateTime Datum { get; set; }

        public int Ocjena { get; set; }

        public int TrenerId { get; set; }

        public int KorisnikId { get; set; }

        //public virtual Korisnici Korisnik { get; set; } = null!;

        //public virtual Treneri Trener { get; set; } = null!;
    }
}
