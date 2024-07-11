using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class KorisniciNovostiInsertRequest
    {
        public int KorisnikId { get; set; }

        public int NovostId { get; set; }

        public bool? IsLiked { get; set; }

        public bool? IsRead { get; set; }
    }
}
