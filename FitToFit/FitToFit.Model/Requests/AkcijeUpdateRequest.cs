using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class AkcijeUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string? Naziv { get; set; } = null!;
        [Required]
        public DateTime? DatumPocetka { get; set; }
        [Required]
        public DateTime? DatumZavrsetka { get; set; }

        public int? Iznos { get; set; }
        public string? StateMachine { get; set; }
    }
}
