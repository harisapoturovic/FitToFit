using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class AkcijeTreninziInsertRequest
    {
        public int TreningId { get; set; }
        public int? AkcijaId { get; set; }
    }
}
