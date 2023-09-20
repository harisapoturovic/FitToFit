using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface IKorisniciService
    {
        public List<Model.Korisnici> Get();
    }
}
