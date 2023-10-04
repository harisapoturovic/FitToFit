using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Akcije
    {
        public int AkcijaId { get; set; }

        public string Naziv { get; set; } = null!;

        public DateTime DatumPocetka { get; set; }

        public DateTime DatumZavrsetka { get; set; }

        public int Iznos { get; set; }
        public string? StateMachine { get; set; }

        public virtual ICollection<AkcijeTreninzi> AkcijeTreninzis { get; set; } = new List<AkcijeTreninzi>();
    }
}
