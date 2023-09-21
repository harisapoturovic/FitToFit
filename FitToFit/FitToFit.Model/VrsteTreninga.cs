using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class VrsteTreninga
    {
        public int VrstaTreningaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public byte[]? SlikaRaspored { get; set; }

        public byte[]? SlikaCjenovnik { get; set; }
    }
}
