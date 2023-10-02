using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Admin
{
    public int AdminId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Spol { get; set; } = null!;

    public string? Telefon { get; set; }

    public string? Email { get; set; }

    public string? Adresa { get; set; }

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public virtual ICollection<Novosti> Novostis { get; set; } = new List<Novosti>();
}
