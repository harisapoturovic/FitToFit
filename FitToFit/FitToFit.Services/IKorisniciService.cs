using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface IKorisniciService : ICRUDService<Model.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public Task<Model.Korisnici> Login(string username, string password);
    }
}

