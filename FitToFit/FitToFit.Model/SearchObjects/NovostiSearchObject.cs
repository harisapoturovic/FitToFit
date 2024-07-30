using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class NovostiSearchObject : BaseSearchObject
    {
        public string? Naslov { get; set; }
        public string? FTS { get; set; }
        public int? VrstaTreningaId { get; set; }
        public int? KorisnikId { get; set; }

    }
}
