using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Treneri
    {
        public int TrenerId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Spol { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string Adresa { get; set; } = null!;

        public DateTime DatumZaposlenja { get; set; }

        public string Zvanje { get; set; } = null!;

        public byte[]? Slika { get; set; }
    }
}
