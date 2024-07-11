using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IKorisniciNovostiService : ICRUDService<Model.KorisniciNovosti, KorisniciNovostiSearchObject, KorisniciNovostiInsertRequest, KorisniciNovostiInsertRequest>
    {
    }
}

