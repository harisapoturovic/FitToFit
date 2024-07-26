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

        public string? StateMachine { get; set; }

        public decimal? Iznos { get; set; }

        public DateTime? DatumIsteka { get; set; }

        //public virtual Korisnici Korisnik { get; set; } = null!; // ???

        public virtual ICollection<RezervacijaStavke> RezervacijaStavkes { get; set; } = new List<RezervacijaStavke>();
    }
}
