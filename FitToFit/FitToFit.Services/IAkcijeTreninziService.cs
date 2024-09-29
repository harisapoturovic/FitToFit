using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public interface IAkcijeTreninziService : IService<Model.AkcijeTreninzi, AkcijeTreninziSearchObject>
    {
        Task<AkcijeTreninzi> Insert(AkcijeTreninziInsertRequest insert);
        Task<AkcijeTreninzi> Delete(int id);
    }
}