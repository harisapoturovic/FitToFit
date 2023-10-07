using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model.Requests
{
    public class NovostiInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Naslov { get; set; } = null!;

        public string? Sadrzaj { get; set; }

        public string? Slika { get; set; }

        public bool? IsLiked { get; set; }

        public DateTime DatumObjave { get; set; }
    
        public int AdminId { get; set; }
        
        public int VrstaTreningaId { get; set; }

        public int BrojLajkova { get; set; }
    }
}
