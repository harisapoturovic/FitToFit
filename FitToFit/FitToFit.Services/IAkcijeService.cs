using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IAkcijeService : ICRUDService<Model.Akcije, AkcijeSearchObject, AkcijeInsertRequest, AkcijeUpdateRequest>
    {
    }
}