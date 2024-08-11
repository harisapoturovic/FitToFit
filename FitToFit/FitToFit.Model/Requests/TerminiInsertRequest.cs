using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TerminiInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Dan { get; set; } = null!;

        public int? BrojClanova { get; set; }
        [Required]
        public int TreningId { get; set; }
        [Required]
        public int TrenerId { get; set; }
        [Required]
        public int SalaId { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string? Sat { get; set; }
    }
}
