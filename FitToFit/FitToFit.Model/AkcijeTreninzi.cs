using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class AkcijeTreninzi
    {
        public int AkcijaTreningId { get; set; }

        public int AkcijaId { get; set; }

        public int TreningId { get; set; }

        //public virtual Akcije Akcija { get; set; } = null!;

        public virtual Treninzi Trening { get; set; } = null!;
    }
}
