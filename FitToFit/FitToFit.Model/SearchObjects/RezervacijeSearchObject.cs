using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class RezervacijeSearchObject : BaseSearchObject
    {
        public DateTime? Datum { get; set; }

        public int? KorisnikId { get; set; }
        public int? TreningId { get; set; }
        public int? ClanarinaId { get; set; }
        public String? StateMachine { get; set; }
        public bool? IsTerminiIncluded { get; set; }
    }
}
