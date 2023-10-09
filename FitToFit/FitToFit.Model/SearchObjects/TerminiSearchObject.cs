using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.SearchObjects
{
    public class TerminiSearchObject : BaseSearchObject
    {
        public string? Dan { get; set; }
        public string? Sat { get; set; }
        public int? TreningId { get; set; }
        public int? TrenerId { get; set; }
        public int? SalaId { get; set; }
    }
}
