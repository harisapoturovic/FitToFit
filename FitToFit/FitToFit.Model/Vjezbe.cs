using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Vjezbe
    {
        public int VjezbaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public byte[]? Slika { get; set; }
        //public virtual ICollection<TreninziVjezbe> TreninziVjezbes { get; set; } = new List<TreninziVjezbe>();
    }
}
