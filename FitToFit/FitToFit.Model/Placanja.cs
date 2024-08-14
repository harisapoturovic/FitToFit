using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Placanja
    {
        public int Id { get; set; }

        public int? KorisnikId { get; set; }

        public DateTime? DatumPlacanja { get; set; }

        public decimal? Iznos { get; set; }

        public string? TransactionId { get; set; }
    }
}
