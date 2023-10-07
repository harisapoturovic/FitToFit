using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class AdminUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Ime { get; set; } = null!;

        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; } = null!;

        public string? Telefon { get; set; }

        public string? Email { get; set; }

        public string? Adresa { get; set; }
    }
}
