using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class TreninziSearchObject : BaseSearchObject
    {
        public string? Naziv { get; set; }
        public string? VrstaTreninga { get; set; }
        public bool? IsVjezbeIncluded { get; set; }
        public bool? IsTerminiIncluded { get; set; }
        public string? VrstaTreningaNaziv { get; set; }
        public string? Namjena { get; set; }
    }
}
