using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class VjezbeTreninziInsertRequest
    {
        public int? TreningId { get; set; }
        public int VjezbaId { get; set; }
        public decimal Trajanje { get; set; }
    }
}
