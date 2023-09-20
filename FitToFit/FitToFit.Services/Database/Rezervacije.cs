using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Rezervacije
{
    public int RezervacijaId { get; set; }

    public DateTime Datum { get; set; }

    public int KorisnikId { get; set; }

    public int ClanarinaId { get; set; }

    public string Status { get; set; } = null!;

    public virtual Clanarine Clanarina { get; set; } = null!;

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<RezervacijaStavke> RezervacijaStavkes { get; set; } = new List<RezervacijaStavke>();
}
