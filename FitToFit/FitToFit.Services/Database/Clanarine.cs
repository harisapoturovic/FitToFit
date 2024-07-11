using System;
using System.Collections.Generic;

namespace FitToFit.Database;

public partial class Clanarine
{
    public int ClanarinaId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual ICollection<TreninziClanarine> TreninziClanarines { get; set; } = new List<TreninziClanarine>();
}
