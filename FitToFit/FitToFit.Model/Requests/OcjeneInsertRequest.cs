using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class OcjeneInsertRequest
    {
        public DateTime Datum { get; set; }

        public int Ocjena { get; set; }

        public int TrenerId { get; set; }

        public int KorisnikId { get; set; }
    }
}
