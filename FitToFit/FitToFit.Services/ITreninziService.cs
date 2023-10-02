using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface ITreninziService : ICRUDService<Model.Treninzi, TreninziSearchObject, TreninziInsertRequest, TreninziUpdateRequest>
    {
    }
}