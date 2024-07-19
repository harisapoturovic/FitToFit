using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IAkcijeService : ICRUDService<Model.Akcije, AkcijeSearchObject, AkcijeInsertRequest, AkcijeUpdateRequest>
    {
        Task<Akcije> Activate(int id);
        Task<Akcije> Archive(int id);
        Task<List<string>> AllowedActions(int id);
        Task<List<Akcije>> GetAkcijeForTrening(int treningId);
    }
}