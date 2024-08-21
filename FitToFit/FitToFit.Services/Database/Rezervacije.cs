using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Rezervacije
{
    public int RezervacijaId { get; set; }

    public DateTime Datum { get; set; }

    public int KorisnikId { get; set; }

    public int ClanarinaId { get; set; }

    public string? StateMachine { get; set; }

    public decimal? Iznos { get; set; }

    public DateTime? DatumIsteka { get; set; }

    public string? BrojTransakcije { get; set; }

    public virtual Clanarine Clanarina { get; set; } = null!;

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<RezervacijaStavke> RezervacijaStavkes { get; set; } = new List<RezervacijaStavke>();
}
