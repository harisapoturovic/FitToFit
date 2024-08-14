using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Korisnici
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Spol { get; set; } = null!;

    public string? Telefon { get; set; }

    public string? Email { get; set; }

    public string? Adresa { get; set; }

    public DateTime? DatumRodjenja { get; set; }

    public DateTime? DatumPocetkaTreniranja { get; set; }

    public string? Visina { get; set; }

    public string? Tezina { get; set; }

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public int? UlogaId { get; set; }

    public virtual ICollection<KorisniciNovosti> KorisniciNovostis { get; set; } = new List<KorisniciNovosti>();

    public virtual ICollection<Novosti> Novostis { get; set; } = new List<Novosti>();

    public virtual ICollection<Ocjene> Ocjenes { get; set; } = new List<Ocjene>();

    public virtual ICollection<Placanja> Placanjas { get; set; } = new List<Placanja>();

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual Uloge? Uloga { get; set; }
}
