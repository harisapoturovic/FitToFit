using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class KorisniciNovosti
{
    public int KorisniciNovostiId { get; set; }

    public int KorisnikId { get; set; }

    public int NovostId { get; set; }

    public bool? IsLiked { get; set; }

    public bool? IsRead { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Novosti Novost { get; set; } = null!;
}
