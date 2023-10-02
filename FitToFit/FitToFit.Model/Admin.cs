using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Admin
    {
        public int AdminId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Spol { get; set; } = null!;

        public string? Telefon { get; set; }

        public string? Email { get; set; }

        public string? Adresa { get; set; }

        public string KorisnickoIme { get; set; } = null!;
    }
}
