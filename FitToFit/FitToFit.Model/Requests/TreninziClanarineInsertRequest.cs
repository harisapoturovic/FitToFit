using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TreninziClanarineInsertRequest
    {
        public int Cijena { get; set; }

        public int? Ucestalost { get; set; }

        public int ClanarinaId { get; set; }

        public int VrstaTreningaId { get; set; }
    }
}
