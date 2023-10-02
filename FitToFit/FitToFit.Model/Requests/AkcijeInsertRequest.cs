using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class AkcijeInsertRequest
    {
        public string Naziv { get; set; } = null!;

        public DateTime DatumPocetka { get; set; }

        public DateTime DatumZavrsetka { get; set; }

        public int Iznos { get; set; }
        public List<AkcijeTreninziInsertRequest>? Items { get; set; }
    }
}
