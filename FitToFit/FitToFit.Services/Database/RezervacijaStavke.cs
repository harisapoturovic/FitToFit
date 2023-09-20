using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class RezervacijaStavke
{
    public int RezervacijaStavkeId { get; set; }

    public int RezervacijaId { get; set; }

    public int TerminId { get; set; }

    public virtual Rezervacije Rezervacija { get; set; } = null!;

    public virtual Termini Termin { get; set; } = null!;
}
