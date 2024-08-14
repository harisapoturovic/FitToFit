using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class RezervacijeUpdateRequest
    {
        [Required]
        public int? ClanarinaId { get; set; }

        public string? StateMachine { get; set; } = null!;
        public decimal? Iznos { get; set; } = null!;
        public int? PlacanjeId { get; set; }
    }
}
