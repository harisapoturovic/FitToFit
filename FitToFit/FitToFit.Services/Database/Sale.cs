using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Sale
{
    public int SalaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Velicina { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<Termini> Terminis { get; set; } = new List<Termini>();
}
