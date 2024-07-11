using System;
using System.Collections.Generic;

namespace FitToFit.Database;

public partial class Treneri
{
    public int TrenerId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Spol { get; set; } = null!;

    public string? Telefon { get; set; }

    public string? Email { get; set; }

    public string? Adresa { get; set; }

    public DateTime DatumZaposlenja { get; set; }

    public string? Zvanje { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<Ocjene> Ocjenes { get; set; } = new List<Ocjene>();

    public virtual ICollection<Termini> Terminis { get; set; } = new List<Termini>();
}
