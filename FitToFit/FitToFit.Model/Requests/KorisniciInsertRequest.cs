using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class KorisniciInsertRequest
    {
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

        public byte[]? Slika { get; set; }
        public string Password { get; set; }
        public string PasswordPotvrda { get; set; } //radi provjere na API-ju
    }
}
