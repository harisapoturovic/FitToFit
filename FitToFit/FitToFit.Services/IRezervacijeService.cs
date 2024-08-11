using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IRezervacijeService : ICRUDService<Model.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        Task<Rezervacije> Activate(int id);
        Task<Rezervacije> Cancel(int id);
        Task<Rezervacije> Refuse(int id);
        Task<Rezervacije> Archive(int id);
        Task<List<string>> AllowedActions(int id);

    }
}