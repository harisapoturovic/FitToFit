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
    public interface INovostiService : ICRUDService<Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>
    {
        Task<Novosti> Insert(NovostiInsertRequest insert);
    }
}
