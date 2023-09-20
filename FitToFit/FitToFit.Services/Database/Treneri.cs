using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Treneri
{
    public int TrenerId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Spol { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Adresa { get; set; } = null!;

    public DateTime DatumZaposlenja { get; set; }

    public string Zvanje { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public virtual ICollection<Ocjene> Ocjenes { get; set; } = new List<Ocjene>();

    public virtual ICollection<Termini> Terminis { get; set; } = new List<Termini>();
}
