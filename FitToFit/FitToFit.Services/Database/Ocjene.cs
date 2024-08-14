using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Ocjene
{
    public int OcjenaId { get; set; }

    public DateTime Datum { get; set; }

    public int Ocjena { get; set; }

    public int TrenerId { get; set; }

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Treneri Trener { get; set; } = null!;
}
