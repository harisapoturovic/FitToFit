using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Treninzi
{
    public int TreningId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public int MaxBrojClanova { get; set; }

    public int CijenaPoTerminu { get; set; }

    public string Trajanje { get; set; } = null!;

    public int ProsjecnaPotrosnjaKalorija { get; set; }

    public int VrstaId { get; set; }

    public string Namjena { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public virtual ICollection<AkcijeTreninzi> AkcijeTreninzis { get; set; } = new List<AkcijeTreninzi>();

    public virtual ICollection<Recommender> Recommenders { get; set; } = new List<Recommender>();

    public virtual ICollection<Termini> Terminis { get; set; } = new List<Termini>();

    public virtual ICollection<TreninziVjezbe> TreninziVjezbes { get; set; } = new List<TreninziVjezbe>();

    public virtual VrsteTreninga Vrsta { get; set; } = null!;
}
