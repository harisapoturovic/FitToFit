using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Rezervacije
    {
        public int RezervacijaId { get; set; }

        public DateTime Datum { get; set; }

        public int KorisnikId { get; set; }

        public int ClanarinaId { get; set; }

        public string Status { get; set; } = null!;

        //public virtual Korisnici Korisnik { get; set; } = null!; // ???

        public virtual ICollection<RezervacijaStavke> RezervacijaStavkes { get; set; } = new List<RezervacijaStavke>();
    }
}
