using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class AkcijeSearchObject : BaseSearchObject
    {
        public string? Naziv { get; set; }
        public DateTime? DatumPocetka { get; set; }
        public bool? IsTreninziIncluded { get; set; }
    }
}
