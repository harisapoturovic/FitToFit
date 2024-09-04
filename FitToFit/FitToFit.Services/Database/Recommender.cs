using System;
using System.Collections.Generic;

namespace FitToFit.Services.Database;

public partial class Recommender
{
    public int Id { get; set; }

    public int TreningId { get; set; }

    public int CoTreningId1 { get; set; }

    public int CoTreningId2 { get; set; }

    public int CoTreningId3 { get; set; }

    public virtual Treninzi Trening { get; set; } = null!;
}
