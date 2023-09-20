using AutoMapper;
using FitToFit.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class KorisniciService : IKorisniciService
    {
        Ib200048Context _context;
        public IMapper _mapper { get; set; }
        public KorisniciService(Ib200048Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public List<Model.Korisnici> Get()
        {
            var entityList = _context.Korisnicis.ToList();

            return _mapper.Map<List<Model.Korisnici>>(entityList);
        }
    }
}
