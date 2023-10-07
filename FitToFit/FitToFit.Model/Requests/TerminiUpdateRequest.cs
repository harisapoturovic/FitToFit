using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TerminiUpdateRequest
    {
        public string? Dan { get; set; } = null!;

        public int? BrojClanova { get; set; }
        [Required]
        public int? TreningId { get; set; }
        [Required]
        public int? TrenerId { get; set; }
        [Required]
        public int? SalaId { get; set; }
        [Required(AllowEmptyStrings = false)]
        [Range(8,20)]
        public decimal? Sat { get; set; }
    }
}
