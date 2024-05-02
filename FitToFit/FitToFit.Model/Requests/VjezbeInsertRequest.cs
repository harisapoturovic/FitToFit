using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class VjezbeInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public byte[]? Slika { get; set; }
        public List<VjezbeTreninziInsertRequest>? Items { get; set; }
    }
}
