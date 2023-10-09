using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Korisnici
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Spol { get; set; } = null!;

        public string? Telefon { get; set; }

        public string? Email { get; set; }

        public string? Adresa { get; set; }

        public DateTime? DatumRodjenja { get; set; }

        public DateTime? DatumPocetkaTreniranja { get; set; }

        public string? Visina { get; set; }

        public string? Tezina { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public string LozinkaHash { get; set; } = null!;

        public string LozinkaSalt { get; set; } = null!;

        public byte[]? Slika { get; set; }

        public int? UlogaId { get; set; }

        public virtual ICollection<Ocjene> Ocjenes { get; set; } = new List<Ocjene>();

        //public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

        public virtual Uloge? Uloga { get; set; }
    }
}
