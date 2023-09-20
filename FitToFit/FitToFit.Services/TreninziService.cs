using FitToFit.Model;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class TreninziService : ITreninziService
    {
        Ib200048Context _context;
        public TreninziService(Ib200048Context context)
        {
                _context = context;
        }

        List<Model.Treninzi> treninzis = new List<Model.Treninzi>()
        {
            new Model.Treninzi()
            {
                TreningID=1,
                Naziv="Trening1"
            }
        };
        public IList<Model.Treninzi> Get()
        {
            var list = _context.Treninzis.ToList();
            return treninzis;
        }
    }
}
