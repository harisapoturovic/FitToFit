using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class KorisniciNovosti
    {
        public int KorisniciNovostiId { get; set; }

        public int KorisnikId { get; set; }

        public int NovostId { get; set; }

        public bool? IsLiked { get; set; }

        public bool? IsRead { get; set; }
    }
}
