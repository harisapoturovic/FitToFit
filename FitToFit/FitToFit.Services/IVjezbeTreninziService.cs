using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IVjezbeTreninziService : IService<Model.TreninziVjezbe, BaseSearchObject>
    {
        Task<TreninziVjezbe> Insert(VjezbeTreninziInsertRequest insert);
        Task<TreninziVjezbe> Delete(int id);
    }
}