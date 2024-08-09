using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface IKorisniciService : ICRUDService<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public Task<Korisnici> Login(string username, string password);

        Task ChangePasswordAsync(KorisniciChangePassword userChangePass);

        Task ChangeUsernameAsync(KorisniciChangeUsername userChangePass);

        Task<Korisnici> Insert(KorisniciInsertRequest insert);

        Task<Korisnici> Delete(int id);
        Task<PagedResult<Korisnici>> Get(KorisniciSearchObject search = null);

    }
}

