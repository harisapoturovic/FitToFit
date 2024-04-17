using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class Clanarine
    {
        public int ClanarinaId { get; set; }

        public string Naziv { get; set; } = null!;

        public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

        public virtual ICollection<TreninziClanarine> TreninziClanarines { get; set; } = new List<TreninziClanarine>();
    }
}
