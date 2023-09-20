using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class VrsteTreninga
{
    public int VrstaTreningaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public byte[]? SlikaRaspored { get; set; }

    public byte[]? SlikaCjenovnik { get; set; }

    public virtual ICollection<Novosti> Novostis { get; set; } = new List<Novosti>();

    public virtual ICollection<TreninziClanarine> TreninziClanarines { get; set; } = new List<TreninziClanarine>();

    public virtual ICollection<Treninzi> Treninzis { get; set; } = new List<Treninzi>();
}
