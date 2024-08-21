using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Services.Database;
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
            CreateMap<Korisnici, Model.Korisnici>();
            CreateMap<KorisniciInsertRequest, Korisnici>();
            CreateMap<KorisniciUpdateRequest, Korisnici>();
            CreateMap<VrsteTreninga, Model.VrsteTreninga>();
            CreateMap<Ocjene, Model.Ocjene>();
            CreateMap<Novosti, Model.Novosti>();
            CreateMap<NovostiInsertRequest, Novosti>();
            CreateMap<NovostiUpdateRequest, Novosti>();
            CreateMap<Treneri, Model.Treneri>();
            CreateMap<TreneriInsertRequest, Treneri>();
            CreateMap<TreneriUpdateRequest, Treneri>();
            CreateMap<Treninzi, Model.Treninzi>();
            CreateMap<TreninziInsertRequest, Treninzi>();
            CreateMap<TreninziUpdateRequest, Treninzi>();
            CreateMap<Termini, Model.Termini>();
            CreateMap<TerminiInsertRequest, Termini>();
            CreateMap<TerminiUpdateRequest, Termini>();
            CreateMap<Vjezbe, Model.Vjezbe>();
            CreateMap<TreninziVjezbe, Model.TreninziVjezbe>();
            CreateMap<VjezbeInsertRequest, Vjezbe>();
            CreateMap<VjezbeUpdateRequest, Vjezbe>();
            CreateMap<VjezbeTreninziInsertRequest, TreninziVjezbe>();
            CreateMap<Akcije, Model.Akcije>();
            CreateMap<AkcijeInsertRequest, Akcije>();
            CreateMap<AkcijeUpdateRequest, Akcije>();
            CreateMap<AkcijeTreninzi, Model.AkcijeTreninzi>();
            CreateMap<AkcijeTreninziInsertRequest, AkcijeTreninzi>();
            CreateMap<TreninziClanarine, Model.TreninziClanarine>();
            CreateMap<TreninziClanarineInsertRequest, TreninziClanarine>();
            CreateMap<TreninziClanarineUpdateRequest, TreninziClanarine>();
            CreateMap<Rezervacije, Model.Rezervacije>();
            CreateMap<RezervacijeInsertRequest, Rezervacije>();
            CreateMap<RezervacijeUpdateRequest, Rezervacije>();
            CreateMap<RezervacijaStavke, Model.RezervacijaStavke>();
            CreateMap<Uloge, Model.Uloge>();
            CreateMap<Clanarine, Model.Clanarine>();
            CreateMap<Sale, Model.Sale>();
            CreateMap<RezervacijaStavke, Model.RezervacijaStavke>();
            CreateMap<Model.RezervacijaStavke, RezervacijaStavke>();
            CreateMap<KorisniciNovosti, Model.KorisniciNovosti>();
            CreateMap<Model.KorisniciNovosti, KorisniciNovosti>();
            CreateMap<KorisniciNovostiInsertRequest, KorisniciNovosti>();
            CreateMap<Ocjene, Model.Ocjene>();
            CreateMap<Model.Ocjene, Ocjene>();
            CreateMap<OcjeneInsertRequest, Ocjene>();
        }
    }
}
