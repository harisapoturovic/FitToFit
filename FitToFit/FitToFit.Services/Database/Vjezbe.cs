using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Vjezbe
{
    public int VjezbaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<TreninziVjezbe> TreninziVjezbes { get; set; } = new List<TreninziVjezbe>();
}
