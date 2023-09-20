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

        public string Telefon { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string Adresa { get; set; } = null!;

        public DateTime DatumRodjenja { get; set; }

        public DateTime DatumPocetkaTreniranja { get; set; }

        public string Visina { get; set; } = null!;

        public string Tezina { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;

        public byte[]? Slika { get; set; }

       // public virtual ICollection<Ocjene> Ocjenes { get; set; } = new List<Ocjene>();

       // public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();
    }
}
