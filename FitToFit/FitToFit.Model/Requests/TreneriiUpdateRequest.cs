using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TreneriUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Ime { get; set; } = null!;

        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; } = null!;

        public string? Telefon { get; set; } = null!;

        public string? Email { get; set; } = null!;

        public string? Adresa { get; set; } = null!;

        public DateTime DatumZaposlenja { get; set; }

        public string? Zvanje { get; set; } = null!;

        public byte[]? Slika { get; set; }
    }
}
