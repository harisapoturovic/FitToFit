using FitToFit.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface IService<T, Tsearch> where Tsearch : class
    {
        Task<PagedResult<T>> Get(Tsearch search = null);
        Task<T> GetById(int id);
    }
}
