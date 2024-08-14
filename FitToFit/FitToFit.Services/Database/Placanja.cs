using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Placanja
{
    public int Id { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime? DatumPlacanja { get; set; }

    public decimal? Iznos { get; set; }

    public string? TransactionId { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();
}
