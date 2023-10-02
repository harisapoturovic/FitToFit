using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class TreninziClanarineSearchObject : BaseSearchObject
    {
        public int? Cijena { get; set; }

        public int? Ucestalost { get; set; }

        public int? ClanarinaId { get; set; }

        public int? VrstaTreningaId { get; set; }
    }
}
