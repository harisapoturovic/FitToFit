using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class KorisniciNovostiSearchObject : BaseSearchObject 
    {
        public int? korisnikId { get; set; }
        public int? novostId { get; set; }
    }
}
