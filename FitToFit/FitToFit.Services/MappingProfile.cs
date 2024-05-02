using AutoMapper;
using FitToFit.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Korisnici, Model.Korisnici>();
            CreateMap<KorisniciInsertRequest, Database.Korisnici>();
            CreateMap<KorisniciUpdateRequest, Database.Korisnici>();
            CreateMap<Database.VrsteTreninga, Model.VrsteTreninga>();
            CreateMap<Database.Ocjene, Model.Ocjene>();
            CreateMap<Database.Novosti, Model.Novosti>();
            CreateMap<NovostiInsertRequest, Database.Novosti>();
            CreateMap<NovostiUpdateRequest, Database.Novosti>();
            CreateMap<Database.Treneri, Model.Treneri>();
            CreateMap<TreneriInsertRequest, Database.Treneri>();
            CreateMap<TreneriUpdateRequest, Database.Treneri>();
            CreateMap<Database.Treninzi, Model.Treninzi>();
            CreateMap<Model.Treninzi, Database.Treninzi>();
            CreateMap<TreninziInsertRequest, Database.Treninzi>();
            CreateMap<TreninziUpdateRequest, Database.Treninzi>();
            CreateMap<Database.Termini, Model.Termini>();
            CreateMap<TerminiInsertRequest, Database.Termini>();
            CreateMap<TerminiUpdateRequest, Database.Termini>();
            CreateMap<Database.Vjezbe, Model.Vjezbe>();
            CreateMap<Database.TreninziVjezbe, Model.TreninziVjezbe>();
            CreateMap<VjezbeInsertRequest, Database.Vjezbe>();
            CreateMap<VjezbeUpdateRequest, Database.Vjezbe>();
            CreateMap<VjezbeTreninziInsertRequest, Database.TreninziVjezbe>();
            CreateMap<Database.Akcije, Model.Akcije>();
            CreateMap<AkcijeInsertRequest, Database.Akcije>();
            CreateMap<AkcijeUpdateRequest, Database.Akcije>();
            CreateMap<Database.AkcijeTreninzi, Model.AkcijeTreninzi>();
            CreateMap<Database.TreninziClanarine, Model.TreninziClanarine>();
            CreateMap<TreninziClanarineInsertRequest, Database.TreninziClanarine>();
            CreateMap<TreninziClanarineUpdateRequest, Database.TreninziClanarine>();
            CreateMap<Database.Rezervacije, Model.Rezervacije>();
            CreateMap<RezervacijeInsertRequest, Database.Rezervacije>();
            CreateMap<RezervacijeUpdateRequest, Database.Rezervacije>();
            CreateMap<Database.RezervacijaStavke, Model.RezervacijaStavke>();
            CreateMap<Database.Uloge, Model.Uloge>();
            CreateMap<AkcijeTreninziInsertRequest, Database.AkcijeTreninzi>();
            CreateMap<Database.Clanarine, Model.Clanarine>();
            CreateMap<Database.Sale, Model.Sale>();
        }
    }
}
