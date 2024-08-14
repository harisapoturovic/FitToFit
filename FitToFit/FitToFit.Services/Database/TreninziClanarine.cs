using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class TreninziClanarine
{
    public int TreningClanarinaId { get; set; }

    public int Cijena { get; set; }

    public int? Ucestalost { get; set; }

    public int ClanarinaId { get; set; }

    public int VrstaTreningaId { get; set; }

    public virtual Clanarine Clanarina { get; set; } = null!;

    public virtual VrsteTreninga VrstaTreninga { get; set; } = null!;
}
