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
        [Required(AllowEmptyStrings = false)]
        public string Ime { get; set; } = null!;

        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; } = null!;

        [Required(AllowEmptyStrings = false)]
        public string Spol { get; set; } = null!;

        public string? Telefon { get; set; }

        public string? Email { get; set; }

        public string? Adresa { get; set; }

        public DateTime? DatumRodjenja { get; set; }

        public DateTime? DatumPocetkaTreniranja { get; set; }

        public string? Visina { get; set; }

        public string? Tezina { get; set; }

        [Required(AllowEmptyStrings = false)]
        public string KorisnickoIme { get; set; } = null!;

        public byte[]? Slika { get; set; }
        [Compare("PasswordPotvrda", ErrorMessage = "Password do not match")]
        public string Password { get; set; }
        [Compare("Password", ErrorMessage = "Password do not match")]
        public string PasswordPotvrda { get; set; } 
        public int? UlogaId { get; set; }
    }
}
