using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Akcije
{
    public int AkcijaId { get; set; }

    public string Naziv { get; set; } = null!;

    public DateTime DatumPocetka { get; set; }

    public DateTime DatumZavrsetka { get; set; }

    public int Iznos { get; set; }

    public virtual ICollection<AkcijeTreninzi> AkcijeTreninzis { get; set; } = new List<AkcijeTreninzi>();
}
