using AutoMapper;
using FitToFit.Database;
using FitToFit.Model.SearchObjects;

namespace FitToFit.Services
{
    public class BaseCRUDService<T, Tdb, Tsearch, Tinsert, Tupdate> : BaseService<T, Tdb, Tsearch> where T : class where Tdb : class where Tsearch : BaseSearchObject
    {
        public BaseCRUDService(Ib200048Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(Tdb entity, Tinsert insert)
        {

        }

        public virtual async Task BeforeUpdate(Tdb db, Tupdate update)
        {

        }

        public virtual async Task<T> Insert(Tinsert insert)
        {
            var set = _context.Set<Tdb>();

            Tdb entity = _mapper.Map<Tdb>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }


        public virtual async Task<T> Update(int id, Tupdate update)
        {
            var set = _context.Set<Tdb>();

            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity);
            await BeforeUpdate(entity, update);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Delete(int id)
        {
            var set = _context.Set<Tdb>();

            var entity = await set.FindAsync(id);

            set.Remove(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }
    }
}
