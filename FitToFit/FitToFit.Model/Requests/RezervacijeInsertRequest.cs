using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class RezervacijeInsertRequest
    {
        public DateTime Datum { get; set; }

        public int KorisnikId { get; set; }

        public int ClanarinaId { get; set; }

        public List<RezervacijaStavkeInsertRequest>? Items { get; set; }
    }
}
