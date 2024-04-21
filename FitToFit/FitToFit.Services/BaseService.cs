using AutoMapper;
using Azure;
using FitToFit.Model;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class BaseService<T, Tdb, Tsearch> : IService<T, Tsearch> where T : class where Tdb : class where Tsearch : BaseSearchObject
    {
        protected Ib200048Context _context;
        protected IMapper _mapper { get; set; }
        public BaseService(Ib200048Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        
        public virtual async Task<PagedResult<T>> Get(Tsearch? search=null)
        {
            var query = _context.Set<Tdb>().AsQueryable();

            var respons = new PagedResult<T>();

            query = AddInclude(query, search);
        
            query = AddFilter(query, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                var list = await query
                   .Skip((int)((search.Page - 1) * search.PageSize))
                   .Take((int)search.PageSize)
                   .ToListAsync();

                respons.Result = _mapper.Map<List<T>>(list);
            }
            else
            {
                var list = await query.ToListAsync();
                respons.Result = _mapper.Map<List<T>>(list);
            }
            respons.Count = query.Count();
            return respons;
        }
        
        public virtual async Task<T> GetById(int id)
        {
            var entity = await _context.Set<Tdb>().FindAsync(id);
        
            return _mapper.Map<T>(entity);
        }
        
        public virtual IQueryable<Tdb> AddFilter(IQueryable<Tdb> query, Tsearch? search = null)
        {
            return query;
        }
        
        public virtual IQueryable<Tdb> AddInclude(IQueryable<Tdb> query, Tsearch search = null)
        {
            return query;
        }
    }
}
