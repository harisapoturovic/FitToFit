using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Novosti
    {
        public int NovostId { get; set; }

        public string Naslov { get; set; } = null!;

        public string? Sadrzaj { get; set; }

        public bool? IsLiked { get; set; }

        public int BrojLajkova { get; set; }

        public DateTime DatumObjave { get; set; }

        public int KorisnikId { get; set; }

        public int? VrstaTreningaId { get; set; }

        public bool? IsRead { get; set; }
    }
}
