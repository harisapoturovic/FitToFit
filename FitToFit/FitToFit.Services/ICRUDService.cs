using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface ICRUDService<T, Tsearch, Tinsert, Tupdate> : IService<T, Tsearch> where Tsearch : class
    {
        Task<T> Insert(Tinsert insert);
        Task<T> Update(int id, Tupdate update);
    }
}
