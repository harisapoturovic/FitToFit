using FitToFit.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface IRezervacijaStavkeService : IService<Model.RezervacijaStavke, BaseSearchObject>
    {
        Task<List<Model.OdabraniTermini>> GetTop3Terms(string? order=null);
        Task<Model.Profit> GetProfitForLast3Years();
    }
}
