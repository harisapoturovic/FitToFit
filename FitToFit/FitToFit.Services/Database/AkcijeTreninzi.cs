using System;
using System.Collections.Generic;

namespace FitToFit.Database;

public partial class AkcijeTreninzi
{
    public int AkcijaTreningId { get; set; }

    public int AkcijaId { get; set; }

    public int TreningId { get; set; }

    public virtual Akcije Akcija { get; set; } = null!;

    public virtual Treninzi Trening { get; set; } = null!;
}
