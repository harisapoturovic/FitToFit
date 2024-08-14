using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Novosti
{
    public int NovostId { get; set; }

    public string Naslov { get; set; } = null!;

    public string? Sadrzaj { get; set; }

    public bool? IsLiked { get; set; }

    public int BrojLajkova { get; set; }

    public DateTime DatumObjave { get; set; }

    public int KorisnikId { get; set; }

    public int? VrstaTreningaId { get; set; }

    public bool? IsRead { get; set; }

    public virtual ICollection<KorisniciNovosti> KorisniciNovostis { get; set; } = new List<KorisniciNovosti>();

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual VrsteTreninga? VrstaTreninga { get; set; }
}
