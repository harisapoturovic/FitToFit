﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class TreneriSearchObject : BaseSearchObject 
    {
        public bool? IsOcjeneIncluded { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
    }
}
