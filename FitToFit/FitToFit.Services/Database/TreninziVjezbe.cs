using System;
using System.Collections.Generic;

namespace FitToFit.Database;

public partial class TreninziVjezbe
{
    public int TreningVjezbaId { get; set; }

    public decimal Trajanje { get; set; }

    public int TreningId { get; set; }

    public int VjezbaId { get; set; }

    public virtual Treninzi Trening { get; set; } = null!;

    public virtual Vjezbe Vjezba { get; set; } = null!;
}
