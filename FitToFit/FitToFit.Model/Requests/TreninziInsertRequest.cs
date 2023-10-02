using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TreninziInsertRequest
    {
        public string Naziv { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public int MaxBrojClanova { get; set; }

        public int CijenaPoTerminu { get; set; }

        public string Trajanje { get; set; } = null!;

        public decimal ProsjecnaPotrosnjaKalorija { get; set; }

        public int VrstaId { get; set; }

        public string Namjena { get; set; } = null!;

        public byte[]? Slika { get; set; }
    }
}
