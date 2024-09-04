using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IVjezbeService : ICRUDService<Model.Vjezbe, VjezbeSearchObject, VjezbeInsertRequest, VjezbeUpdateRequest>
    {
    }
}