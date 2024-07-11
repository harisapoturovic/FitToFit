using System;
using System.Collections.Generic;

namespace FitToFit.Database;

public partial class Treninzi
{
    public int TreningId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public int MaxBrojClanova { get; set; }

    public decimal CijenaPoTerminu { get; set; }

    public string Trajanje { get; set; } = null!;

    public decimal ProsjecnaPotrosnjaKalorija { get; set; }

    public int VrstaId { get; set; }

    public string Namjena { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public virtual ICollection<AkcijeTreninzi> AkcijeTreninzis { get; set; } = new List<AkcijeTreninzi>();

    public virtual ICollection<Termini> Terminis { get; set; } = new List<Termini>();

    public virtual ICollection<TreninziVjezbe> TreninziVjezbes { get; set; } = new List<TreninziVjezbe>();

    public virtual VrsteTreninga Vrsta { get; set; } = null!;
}
