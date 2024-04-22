using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Sale
    {
        public int SalaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Velicina { get; set; }

        public byte[]? Slika { get; set; }

        public virtual ICollection<Termini> Terminis { get; set; } = new List<Termini>();
    }
}
