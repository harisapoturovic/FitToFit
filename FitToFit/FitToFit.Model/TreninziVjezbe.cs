using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class TreninziVjezbe
    {
        public int TreningVjezbaId { get; set; }

        public decimal Trajanje { get; set; }

        public int TreningId { get; set; }

        public int VjezbaId { get; set; }

        public virtual Vjezbe Vjezba { get; set; } = null!;

        //public virtual Treninzi Trening { get; set; } = null!;
    }
}
