using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TreninziClanarineUpdateRequest
    {
        [Required]
        public int? Cijena { get; set; }
        [Required]
        public int? Ucestalost { get; set; }
        [Required]
        public int? ClanarinaId { get; set; }
        [Required]
        public int? VrstaTreningaId { get; set; }
    }
}
