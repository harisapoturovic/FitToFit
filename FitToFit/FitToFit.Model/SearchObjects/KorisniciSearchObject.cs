using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class KorisniciSearchObject : BaseSearchObject 
    {
        public bool? IsOcjeneIncluded { get; set; }
        public bool? IsUlogeIncluded { get; set; }
    }
}
