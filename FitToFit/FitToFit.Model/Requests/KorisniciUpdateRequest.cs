using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class KorisniciUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Ime { get; set; } = null!;
        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; } = null!;

        //public string Spol { get; set; } = null!;

        public string? Telefon { get; set; }

        public string? Email { get; set; }

        public string? Adresa { get; set; }

        //public DateTime? DatumRodjenja { get; set; }

        public DateTime? DatumPocetkaTreniranja { get; set; }

        public string? Visina { get; set; }

        public string? Tezina { get; set; }

        public byte[]? Slika { get; set; }
    }
}
