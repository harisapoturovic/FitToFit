using System;
using System.Collections.Generic;

namespace FitToFit.Database;

public partial class Termini
{
    public int TerminId { get; set; }

    public string Dan { get; set; } = null!;

    public int? BrojClanova { get; set; }

    public int TreningId { get; set; }

    public int TrenerId { get; set; }

    public int SalaId { get; set; }

    public string? Sat { get; set; }

    public virtual ICollection<RezervacijaStavke> RezervacijaStavkes { get; set; } = new List<RezervacijaStavke>();

    public virtual Sale Sala { get; set; } = null!;

    public virtual Treneri Trener { get; set; } = null!;

    public virtual Treninzi Trening { get; set; } = null!;
}
