using FitToFit.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class TreninziService : ITreninziService
    {
        List<Treninzi> treninzis = new List<Treninzi>()
        {
            new Treninzi()
            {
                TreningID=1,
                Naziv="Trening1"
            }
        };
        public IList<Treninzi> Get()
        {
            return treninzis;
        }
    }
}
