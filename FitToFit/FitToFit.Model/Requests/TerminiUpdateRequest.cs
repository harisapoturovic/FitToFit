﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class TerminiUpdateRequest
    {
        public string? Dan { get; set; } = null!;

        public string? Sat { get; set; } = null!;

        public int? BrojClanova { get; set; }

        public int? TreningId { get; set; }

        public int? TrenerId { get; set; }

        public int? SalaId { get; set; }
    }
}
