using FitToFit.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace FitToFit.Services.Database
{
    public partial class _200048Context
    {
        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedVrsteTreninga(modelBuilder);
            SeedTreneri(modelBuilder);
            SeedUloge(modelBuilder);
            SeedSale(modelBuilder);
            SeedKorisnici(modelBuilder);
            SeedNovosti(modelBuilder);
            SeedClanarine(modelBuilder);
            SeedOcjene(modelBuilder);
            SeedVjezbe(modelBuilder);
            SeedTreninzi(modelBuilder);
            SeedTreninziVjezbe(modelBuilder);
            SeedTreninziClanarine(modelBuilder);
            SeedTermini(modelBuilder);
            SeedAkcije(modelBuilder);
            SeedAkcijeTreninzi(modelBuilder);
            SeedRezervacije(modelBuilder);
            SeedRezervacijeStavke(modelBuilder);
            SeedKorisniciNovosti(modelBuilder);
        }

        private void SeedKorisniciNovosti(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<KorisniciNovosti>().HasData(
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 1,
                    KorisnikId = 1,
                    NovostId = 1,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 2,
                    KorisnikId = 1,
                    NovostId = 2,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 3,
                    KorisnikId = 1,
                    NovostId = 3,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 4,
                    KorisnikId = 1,
                    NovostId = 4,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 5,
                    KorisnikId = 1,
                    NovostId = 5,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 6,
                    KorisnikId = 1,
                    NovostId = 6,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 7,
                    KorisnikId = 1,
                    NovostId = 7,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 8,
                    KorisnikId = 2,
                    NovostId = 2,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 9,
                    KorisnikId = 2,
                    NovostId = 4,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 10,
                    KorisnikId = 2,
                    NovostId = 5,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 11,
                    KorisnikId = 3,
                    NovostId = 6,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 12,
                    KorisnikId = 3,
                    NovostId = 7,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 13,
                    KorisnikId = 4,
                    NovostId = 4,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 14,
                    KorisnikId = 4,
                    NovostId = 2,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 15,
                    KorisnikId = 5,
                    NovostId = 6,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 16,
                    KorisnikId = 5,
                    NovostId = 7,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 17,
                    KorisnikId = 5,
                    NovostId = 2,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 18,
                    KorisnikId = 6,
                    NovostId = 6,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 19,
                    KorisnikId = 6,
                    NovostId = 3,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 20,
                    KorisnikId = 6,
                    NovostId = 1,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 21,
                    KorisnikId = 7,
                    NovostId = 7,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 22,
                    KorisnikId = 7,
                    NovostId = 4,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 23,
                    KorisnikId = 7,
                    NovostId = 2,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 24,
                    KorisnikId = 8,
                    NovostId = 7,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 25,
                    KorisnikId = 8,
                    NovostId = 2,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 26,
                    KorisnikId = 8,
                    NovostId = 4,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 27,
                    KorisnikId = 9,
                    NovostId = 3,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 28,
                    KorisnikId = 9,
                    NovostId = 1,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 29,
                    KorisnikId = 9,
                    NovostId = 5,
                    IsLiked = false,
                    IsRead = false
                },
                new KorisniciNovosti()
                {
                    KorisniciNovostiId = 30,
                    KorisnikId = 9,
                    NovostId = 4,
                    IsLiked = false,
                    IsRead = false
                });
        }

        private void SeedRezervacijeStavke(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<RezervacijaStavke>().HasData(
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 1,
                   RezervacijaId = 1,
                   TerminId = 1
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 2,
                   RezervacijaId = 1,
                   TerminId = 20
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 3,
                    RezervacijaId = 2,
                    TerminId = 6
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 4,
                   RezervacijaId = 2,
                   TerminId = 29
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 5,
                    RezervacijaId = 3,
                    TerminId = 4
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 6,
                   RezervacijaId = 4,
                   TerminId = 7
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 7,
                    RezervacijaId = 5,
                    TerminId = 5
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 8,
                   RezervacijaId = 6,
                   TerminId = 9
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 9,
                    RezervacijaId = 7,
                    TerminId = 8
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 10,
                   RezervacijaId = 8,
                   TerminId = 16
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 11,
                    RezervacijaId = 8,
                    TerminId = 21
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 12,
                   RezervacijaId = 9,
                   TerminId = 14
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 13,
                    RezervacijaId = 9,
                    TerminId = 27
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 14,
                   RezervacijaId = 9,
                   TerminId = 25
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 15,
                    RezervacijaId = 10,
                    TerminId = 19
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 16,
                   RezervacijaId = 10,
                   TerminId = 28
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 17,
                   RezervacijaId = 11,
                   TerminId = 32
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 18,
                    RezervacijaId = 11,
                    TerminId = 34
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 19,
                   RezervacijaId = 12,
                   TerminId = 38
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 20,
                    RezervacijaId = 12,
                    TerminId = 21
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 21,
                   RezervacijaId = 13,
                   TerminId = 21
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 22,
                    RezervacijaId = 13,
                    TerminId = 13
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 23,
                   RezervacijaId = 14,
                   TerminId = 28
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 24,
                   RezervacijaId = 1,
                   TerminId = 30
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 25,
                   RezervacijaId = 2,
                   TerminId = 21
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 26,
                   RezervacijaId = 2,
                   TerminId = 38
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 27,
                    RezervacijaId = 3,
                    TerminId = 22
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 28,
                   RezervacijaId = 4,
                   TerminId = 26
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 29,
                    RezervacijaId = 5,
                    TerminId = 15
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 30,
                   RezervacijaId = 6,
                   TerminId = 18
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 31,
                   RezervacijaId = 7,
                   TerminId = 21
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 32,
                   RezervacijaId = 7,
                   TerminId = 38
               },
                new RezervacijaStavke()
                {
                    RezervacijaStavkeId = 33,
                    RezervacijaId = 14,
                    TerminId = 35
                },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 34,
                   RezervacijaId = 14,
                   TerminId = 4
               },
               new RezervacijaStavke()
               {
                   RezervacijaStavkeId = 35,
                   RezervacijaId = 1,
                   TerminId = 33
               });
        }

        private void SeedRezervacije(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Rezervacije>().HasData(
                new Rezervacije()
                {
                    RezervacijaId = 1,
                    Datum = new DateTime(2024, 4, 21),
                    DatumIsteka = new DateTime(2024, 5, 21),
                    KorisnikId = 2,
                    ClanarinaId = 1,
                    Iznos = 25,
                    StateMachine = "refused",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 2,
                    Datum = new DateTime(2023, 7, 20),
                    DatumIsteka = new DateTime(2023, 7, 27),
                    KorisnikId = 1,
                    ClanarinaId = 2,
                    Iznos = 5,
                    StateMachine = "canceled",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 3,
                    Datum = new DateTime(2023, 3, 21),
                    DatumIsteka = new DateTime(2024, 4, 21),
                    KorisnikId = 3,
                    ClanarinaId = 1,
                    Iznos = 30,
                    StateMachine = "active",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 4,
                    Datum = new DateTime(2023, 9, 20),
                    DatumIsteka = new DateTime(2023, 10, 20),
                    KorisnikId = 4,
                    ClanarinaId = 1,
                    Iznos = 30,
                    StateMachine = "archived",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 5,
                    Datum = new DateTime(2023, 9, 10),
                    DatumIsteka = new DateTime(2023, 10, 10),
                    KorisnikId = 5,
                    ClanarinaId = 1,
                    Iznos = 40,
                    StateMachine = "archived",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 6,
                    Datum = new DateTime(2022, 7, 20),
                    DatumIsteka = new DateTime(2022, 8, 20),
                    KorisnikId = 6,
                    ClanarinaId = 1,
                    Iznos = 45,
                    StateMachine = "archived",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 7,
                    Datum = new DateTime(2022, 1, 20),
                    DatumIsteka = new DateTime(2022, 2, 20),
                    KorisnikId = 7,
                    ClanarinaId = 1,
                    Iznos = 50,
                    StateMachine = "archived",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 8,
                    Datum = new DateTime(2022, 3, 20),
                    DatumIsteka = new DateTime(2022, 4, 20),
                    KorisnikId = 8,
                    ClanarinaId = 1,
                    Iznos = 35,
                    StateMachine = "archived",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 9,
                    Datum = new DateTime(2024, 8, 4),
                    DatumIsteka = new DateTime(2024, 9, 3),
                    KorisnikId = 5,
                    ClanarinaId = 1,
                    Iznos = 40,
                    StateMachine = "active",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 10,
                    Datum = new DateTime(2024, 8, 7),
                    DatumIsteka = new DateTime(2024, 9, 6),
                    KorisnikId = 1,
                    ClanarinaId = 1,
                    Iznos = 45,
                    StateMachine = "active",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 11,
                    Datum = new DateTime(2024, 8, 12),
                    DatumIsteka = new DateTime(2024, 8, 19),
                    KorisnikId = 2,
                    ClanarinaId = 2,
                    Iznos = 15,
                    StateMachine = "active",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 12,
                    Datum = new DateTime(2024, 8, 12),
                    DatumIsteka = new DateTime(2024, 8, 13),
                    KorisnikId = 3,
                    ClanarinaId = 1,
                    Iznos = 3,
                    StateMachine = "active",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 13,
                    Datum = new DateTime(2024, 8, 12),
                    DatumIsteka = new DateTime(2024, 8, 19),
                    KorisnikId = 4,
                    ClanarinaId = 2,
                    Iznos = 10,
                    StateMachine = "draft",
                    BrojTransakcije = null
                },
                new Rezervacije()
                {
                    RezervacijaId = 14,
                    Datum = new DateTime(2024, 8, 12),
                    DatumIsteka = new DateTime(2024, 9, 11),
                    KorisnikId = 9,
                    ClanarinaId = 1,
                    Iznos = 30,
                    StateMachine = "draft",
                    BrojTransakcije = null
                });
        }

        private void SeedAkcijeTreninzi(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AkcijeTreninzi>().HasData(
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 1,
                     AkcijaId = 1,
                     TreningId = 1
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 2,
                     AkcijaId = 2,
                     TreningId = 5
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 3,
                     AkcijaId = 1,
                     TreningId = 5
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 4,
                     AkcijaId = 3,
                     TreningId = 3
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 5,
                     AkcijaId = 4,
                     TreningId = 11
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 6,
                     AkcijaId = 5,
                     TreningId = 2
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 7,
                     AkcijaId = 6,
                     TreningId = 10
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 8,
                     AkcijaId = 7,
                     TreningId = 11
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 9,
                     AkcijaId = 8,
                     TreningId = 1
                 },
                 new AkcijeTreninzi()
                 {
                     AkcijaTreningId = 10,
                     AkcijaId = 3,
                     TreningId = 10
                 });
        }

        private void SeedAkcije(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Akcije>().HasData(
                new Akcije()
                {
                    AkcijaId = 1,
                    Naziv = "Dan žena",
                    DatumPocetka = new DateTime(2024, 3, 7),
                    DatumZavrsetka = new DateTime(2024, 3, 9),
                    Iznos = 20,
                    StateMachine = "archived"
                },
                new Akcije()
                {
                    AkcijaId = 2,
                    Naziv = "Martovska",
                    DatumPocetka = new DateTime(2024, 3, 20),
                    DatumZavrsetka = new DateTime(2024, 3, 30),
                    Iznos = 10,
                    StateMachine = "archived"
                },
                new Akcije()
                {
                    AkcijaId = 3,
                    Naziv = "Aprilska",
                    DatumPocetka = new DateTime(2024, 4, 7),
                    DatumZavrsetka = new DateTime(2024, 4, 20),
                    Iznos = 5,
                    StateMachine = "archived"
                },
                new Akcije()
                {
                    AkcijaId = 4,
                    Naziv = "**Individualni**",
                    DatumPocetka = new DateTime(2024, 7, 26),
                    DatumZavrsetka = new DateTime(2024, 7, 29),
                    Iznos = 10,
                    StateMachine = "archived"
                },
                new Akcije()
                {
                    AkcijaId = 5,
                    Naziv = "Pilates Transformacija: Snaga i Fleksibilnost",
                    DatumPocetka = new DateTime(2024, 8, 2),
                    DatumZavrsetka = new DateTime(2024, 8, 15),
                    Iznos = 10,
                    StateMachine = "active"
                },
                new Akcije()
                {
                    AkcijaId = 6,
                    Naziv = "Hatha Harmonija: Osvježite Um i Tijelo",
                    DatumPocetka = new DateTime(2024, 8, 1),
                    DatumZavrsetka = new DateTime(2024, 8, 22),
                    Iznos = 15,
                    StateMachine = "active"
                },
                new Akcije()
                {
                    AkcijaId = 7,
                    Naziv = "Individualni Izazov: Postignite Svoje Ciljeve",
                    DatumPocetka = new DateTime(2024, 8, 3),
                    DatumZavrsetka = new DateTime(2024, 8, 16),
                    Iznos = 10,
                    StateMachine = "active"
                },
                new Akcije()
                {
                    AkcijaId = 8,
                    Naziv = "Kružna Invazija: Osvoji Snagu!",
                    DatumPocetka = new DateTime(2024, 8, 11),
                    DatumZavrsetka = new DateTime(2024, 8, 30),
                    Iznos = 15,
                    StateMachine = "draft"
                });
        }

        private void SeedTermini(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Termini>().HasData(
               new Termini()
               {
                   TerminId = 1,
                   Dan = "Ponedjeljak",
                   Sat = "08:00h",
                   BrojClanova = 5,
                   TreningId = 1,
                   TrenerId = 1,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 2,
                   Dan = "Ponedjeljak",
                   Sat = "10:00h",
                   BrojClanova = 0,
                   TreningId = 1,
                   TrenerId = 1,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 3,
                   Dan = "Srijeda",
                   Sat = "08:00h",
                   BrojClanova = 5,
                   TreningId = 1,
                   TrenerId = 2,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 4,
                   Dan = "Srijeda",
                   Sat = "10:00h",
                   BrojClanova = 5,
                   TreningId = 1,
                   TrenerId = 2,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 5,
                   Dan = "Petak",
                   Sat = "08:00h",
                   BrojClanova = 0,
                   TreningId = 1,
                   TrenerId = 1,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 6,
                   Dan = "Petak",
                   Sat = "10:00h",
                   BrojClanova = 0,
                   TreningId = 1,
                   TrenerId = 1,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 7,
                   Dan = "Ponedjeljak",
                   Sat = "17:00h",
                   BrojClanova = 3,
                   TreningId = 1,
                   TrenerId = 2,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 8,
                   Dan = "Srijeda",
                   Sat = "17:00h",
                   BrojClanova = 5,
                   TreningId = 1,
                   TrenerId = 2,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 9,
                   Dan = "Petak",
                   Sat = "17:00h",
                   BrojClanova = 4,
                   TreningId = 1,
                   TrenerId = 2,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 10,
                   Dan = "Utorak",
                   Sat = "20:00h",
                   BrojClanova = 0,
                   TreningId = 1,
                   TrenerId = 1,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 11,
                   Dan = "Četvrtak",
                   Sat = "20:00h",
                   BrojClanova = 7,
                   TreningId = 1,
                   TrenerId = 1,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 12,
                   Dan = "Ponedjeljak",
                   Sat = "16:00h",
                   BrojClanova = 5,
                   TreningId = 7,
                   TrenerId = 3,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 13,
                   Dan = "Srijeda",
                   Sat = "17:00h",
                   BrojClanova = 4,
                   TreningId = 7,
                   TrenerId = 3,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 14,
                   Dan = "Ponedjeljak",
                   Sat = "17:00h",
                   BrojClanova = 3,
                   TreningId = 2,
                   TrenerId = 4,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 15,
                   Dan = "Utorak",
                   Sat = "17:00h",
                   BrojClanova = 4,
                   TreningId = 2,
                   TrenerId = 4,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 16,
                   Dan = "Četvrtak",
                   Sat = "17:00h",
                   BrojClanova = 3,
                   TreningId = 2,
                   TrenerId = 4,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 17,
                   Dan = "Petak",
                   Sat = "17:00h",
                   BrojClanova = 4,
                   TreningId = 2,
                   TrenerId = 4,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 18,
                   Dan = "Ponedjeljak",
                   Sat = "19:00h",
                   BrojClanova = 10,
                   TreningId = 3,
                   TrenerId = 5,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 19,
                   Dan = "Srijeda",
                   Sat = "19:00h",
                   BrojClanova = 8,
                   TreningId = 3,
                   TrenerId = 5,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 20,
                   Dan = "Četvrtak",
                   Sat = "18:00h",
                   BrojClanova = 8,
                   TreningId = 3,
                   TrenerId = 5,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 21,
                   Dan = "Srijeda",
                   Sat = "16:00h",
                   BrojClanova = 8,
                   TreningId = 5,
                   TrenerId = 2,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 22,
                   Dan = "Utorak",
                   Sat = "16:00h",
                   BrojClanova = 6,
                   TreningId = 4,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 23,
                   Dan = "Srijeda",
                   Sat = "16:00h",
                   BrojClanova = 5,
                   TreningId = 4,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 24,
                   Dan = "Četvrtak",
                   Sat = "16:00h",
                   BrojClanova = 7,
                   TreningId = 4,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 25,
                   Dan = "Utorak",
                   Sat = "18:00h",
                   BrojClanova = 12,
                   TreningId = 6,
                   TrenerId = 1,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 26,
                   Dan = "Četvrtak",
                   Sat = "18:00h",
                   BrojClanova = 10,
                   TreningId = 6,
                   TrenerId = 1,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 27,
                   Dan = "Petak",
                   Sat = "18:00h",
                   BrojClanova = 6,
                   TreningId = 6,
                   TrenerId = 1,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 28,
                   Dan = "Ponedjeljak",
                   Sat = "19:00h",
                   BrojClanova = 5,
                   TreningId = 8,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 29,
                   Dan = "Petak",
                   Sat = "19:00h",
                   BrojClanova = 5,
                   TreningId = 8,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 30,
                   Dan = "Ponedjeljak",
                   Sat = "20:00h",
                   BrojClanova = 6,
                   TreningId = 9,
                   TrenerId = 7,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 31,
                   Dan = "Srijeda",
                   Sat = "20:00h",
                   BrojClanova = 5,
                   TreningId = 9,
                   TrenerId = 7,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 32,
                   Dan = "Ponedjeljak",
                   Sat = "18:00h",
                   BrojClanova = 5,
                   TreningId = 10,
                   TrenerId = 6,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 33,
                   Dan = "Srijeda",
                   Sat = "18:00h",
                   BrojClanova = 3,
                   TreningId = 10,
                   TrenerId = 6,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 34,
                   Dan = "Ponedjeljak",
                   Sat = "09:00h",
                   BrojClanova = 1,
                   TreningId = 11,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 35,
                   Dan = "Utorak",
                   Sat = "09:00h",
                   BrojClanova = 0,
                   TreningId = 11,
                   TrenerId = 6,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 36,
                   Dan = "Petak",
                   Sat = "09:00h",
                   BrojClanova = 0,
                   TreningId = 11,
                   TrenerId = 5,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 37,
                   Dan = "Srijeda",
                   Sat = "18:00h",
                   BrojClanova = 0,
                   TreningId = 11,
                   TrenerId = 5,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 38,
                   Dan = "Petak",
                   Sat = "18:00h",
                   BrojClanova = 1,
                   TreningId = 11,
                   TrenerId = 4,
                   SalaId = 2
               },
               new Termini()
               {
                   TerminId = 39,
                   Dan = "Utorak",
                   Sat = "20:00h",
                   BrojClanova = 0,
                   TreningId = 11,
                   TrenerId = 4,
                   SalaId = 1
               },
               new Termini()
               {
                   TerminId = 40,
                   Dan = "Srijeda",
                   Sat = "20:00h",
                   BrojClanova = 0,
                   TreningId = 11,
                   TrenerId = 4,
                   SalaId = 1
               });
        }

        private void SeedTreninziClanarine(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TreninziClanarine>().HasData(
                new TreninziClanarine()
                {
                    TreningClanarinaId = 1,
                    Cijena = 20,
                    Ucestalost = 2,
                    ClanarinaId = 1,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 2,
                    Cijena = 25,
                    Ucestalost = 3,
                    ClanarinaId = 1,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 3,
                    Cijena = 3,
                    Ucestalost = 1,
                    ClanarinaId = 3,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 4,
                    Cijena = 5,
                    Ucestalost = 2,
                    ClanarinaId = 2,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 5,
                    Cijena = 5,
                    Ucestalost = 1,
                    ClanarinaId = 3,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 6,
                    Cijena = 7,
                    Ucestalost = 1,
                    ClanarinaId = 3,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 7,
                    Cijena = 7,
                    Ucestalost = 3,
                    ClanarinaId = 2,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 8,
                    Cijena = 10,
                    Ucestalost = 4,
                    ClanarinaId = 2,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 9,
                    Cijena = 12,
                    Ucestalost = 5,
                    ClanarinaId = 2,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 10,
                    Cijena = 30,
                    Ucestalost = 4,
                    ClanarinaId = 1,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 11,
                    Cijena = 40,
                    Ucestalost = 5,
                    ClanarinaId = 1,
                    VrstaTreningaId = 1
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 12,
                    Cijena = 7,
                    Ucestalost = 2,
                    ClanarinaId = 2,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 13,
                    Cijena = 9,
                    Ucestalost = 3,
                    ClanarinaId = 2,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 14,
                    Cijena = 12,
                    Ucestalost = 4,
                    ClanarinaId = 2,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 15,
                    Cijena = 14,
                    Ucestalost = 5,
                    ClanarinaId = 2,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 16,
                    Cijena = 10,
                    Ucestalost = 2,
                    ClanarinaId = 2,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 17,
                    Cijena = 12,
                    Ucestalost = 3,
                    ClanarinaId = 2,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 18,
                    Cijena = 15,
                    Ucestalost = 4,
                    ClanarinaId = 2,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 19,
                    Cijena = 17,
                    Ucestalost = 5,
                    ClanarinaId = 2,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 20,
                    Cijena = 25,
                    Ucestalost = 2,
                    ClanarinaId = 1,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 21,
                    Cijena = 30,
                    Ucestalost = 3,
                    ClanarinaId = 1,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 22,
                    Cijena = 40,
                    Ucestalost = 4,
                    ClanarinaId = 1,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 23,
                    Cijena = 50,
                    Ucestalost = 5,
                    ClanarinaId = 1,
                    VrstaTreningaId = 3
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 24,
                    Cijena = 30,
                    Ucestalost = 2,
                    ClanarinaId = 1,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 25,
                    Cijena = 40,
                    Ucestalost = 3,
                    ClanarinaId = 1,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 26,
                    Cijena = 50,
                    Ucestalost = 4,
                    ClanarinaId = 1,
                    VrstaTreningaId = 2
                },
                new TreninziClanarine()
                {
                    TreningClanarinaId = 27,
                    Cijena = 60,
                    Ucestalost = 5,
                    ClanarinaId = 1,
                    VrstaTreningaId = 2
                });
        }

        private void SeedTreninziVjezbe(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TreninziVjezbe>().HasData(
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 1,
                    Trajanje = 3,
                    TreningId = 3,
                    VjezbaId = 3,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 2,
                    Trajanje = 5,
                    TreningId = 1,
                    VjezbaId = 1,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 3,
                    Trajanje = 3,
                    TreningId = 1,
                    VjezbaId = 6,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 4,
                    Trajanje = 4,
                    TreningId = 1,
                    VjezbaId = 3,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 5,
                    Trajanje = 1,
                    TreningId = 1,
                    VjezbaId = 2
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 6,
                    Trajanje = 3,
                    TreningId = 2,
                    VjezbaId = 9,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 7,
                    Trajanje = 4,
                    TreningId = 2,
                    VjezbaId = 8,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 8,
                    Trajanje = 3,
                    TreningId = 2,
                    VjezbaId = 7,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 9,
                    Trajanje = 2,
                    TreningId = 3,
                    VjezbaId = 11,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 10,
                    Trajanje = 4,
                    TreningId = 3,
                    VjezbaId = 10
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 11,
                    Trajanje = 5,
                    TreningId = 4,
                    VjezbaId = 18,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 12,
                    Trajanje = 5,
                    TreningId = 4,
                    VjezbaId = 19,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 13,
                    Trajanje = 3,
                    TreningId = 5,
                    VjezbaId = 4,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 14,
                    Trajanje = 3,
                    TreningId = 5,
                    VjezbaId = 12
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 15,
                    Trajanje = 5,
                    TreningId = 5,
                    VjezbaId = 13,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 16,
                    Trajanje = 5,
                    TreningId = 6,
                    VjezbaId = 15,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 17,
                    Trajanje = 5,
                    TreningId = 5,
                    VjezbaId = 14
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 18,
                    Trajanje = 4,
                    TreningId = 7,
                    VjezbaId = 8,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 19,
                    Trajanje = 5,
                    TreningId = 7,
                    VjezbaId = 13,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 20,
                    Trajanje = 4,
                    TreningId = 8,
                    VjezbaId = 11
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 21,
                    Trajanje = 4,
                    TreningId = 8,
                    VjezbaId = 21
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 22,
                    Trajanje = 5,
                    TreningId = 8,
                    VjezbaId = 6,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 23,
                    Trajanje = 2,
                    TreningId = 8,
                    VjezbaId = 2,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 24,
                    Trajanje = 5,
                    TreningId = 9,
                    VjezbaId = 16
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 25,
                    Trajanje = 5,
                    TreningId = 9,
                    VjezbaId = 17
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 26,
                    Trajanje = 5,
                    TreningId = 10,
                    VjezbaId = 18,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 27,
                    Trajanje = 5,
                    TreningId = 10,
                    VjezbaId = 19,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 28,
                    Trajanje = 4,
                    TreningId = 11,
                    VjezbaId = 21
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 29,
                    Trajanje = 4,
                    TreningId = 11,
                    VjezbaId = 2
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 30,
                    Trajanje = 4,
                    TreningId = 11,
                    VjezbaId = 1
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 31,
                    Trajanje = 4,
                    TreningId = 1,
                    VjezbaId = 5
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 32,
                    Trajanje = 5,
                    TreningId = 9,
                    VjezbaId = 20,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 33,
                    Trajanje = 4,
                    TreningId = 2,
                    VjezbaId = 13,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 34,
                    Trajanje = 4,
                    TreningId = 4,
                    VjezbaId = 20
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 35,
                    Trajanje = 4,
                    TreningId = 4,
                    VjezbaId = 9
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 36,
                    Trajanje = 5,
                    TreningId = 10,
                    VjezbaId = 8
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 37,
                    Trajanje = 3,
                    TreningId = 10,
                    VjezbaId = 12
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 38,
                    Trajanje = 4,
                    TreningId = 3,
                    VjezbaId = 21,
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 39,
                    Trajanje = 4,
                    TreningId = 5,
                    VjezbaId = 2
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 40,
                    Trajanje = 5,
                    TreningId = 5,
                    VjezbaId = 6
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 41,
                    Trajanje = 5,
                    TreningId = 6,
                    VjezbaId = 14
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 42,
                    Trajanje = 3,
                    TreningId = 6,
                    VjezbaId = 21
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 43,
                    Trajanje = 3,
                    TreningId = 6,
                    VjezbaId = 5
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 44,
                    Trajanje = 5,
                    TreningId = 8,
                    VjezbaId = 3
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 45,
                    Trajanje = 5,
                    TreningId = 8,
                    VjezbaId = 4
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 46,
                    Trajanje = 4,
                    TreningId = 7,
                    VjezbaId = 7
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 47,
                    Trajanje = 4,
                    TreningId = 7,
                    VjezbaId = 9
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 48,
                    Trajanje = 5,
                    TreningId = 7,
                    VjezbaId = 14
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 49,
                    Trajanje = 5,
                    TreningId = 11,
                    VjezbaId = 3
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 50,
                    Trajanje = 4,
                    TreningId = 11,
                    VjezbaId = 4
                },
                new TreninziVjezbe()
                {
                    TreningVjezbaId = 51,
                    Trajanje = 4,
                    TreningId = 11,
                    VjezbaId = 20
                });
        }

        private void SeedTreninzi(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Treninzi>().HasData(
               new Treninzi()
               {
                   TreningId = 1,
                   Naziv = "Kružni",
                   Opis = "Kružni trening je učinkovit način vježbanja koji uključuje seriju vježbi izvedenih u kratkim intervalima s minimalnim odmorom između njih. Cilj je raditi različite vježbe koje pokrivaju sve glavne mišićne skupine, čime se poboljšava snaga, izdržljivost i kondicija. Svaka vježba traje od 30 do 60 sekundi, a zatim slijedi prijelaz na sljedeću. Kružni trening može uključivati vježbe s vlastitom tjelesnom težinom, utezima ili opremom. Ova metoda je odlična za poboljšanje ukupne tjelesne forme u kratkom vremenu.",
                   MaxBrojClanova = 10,
                   CijenaPoTerminu = 3,
                   Trajanje = "60 min",
                   ProsjecnaPotrosnjaKalorija = 600,
                   VrstaId = 1,
                   Namjena = "Mršavljenje"
               },
               new Treninzi()
               {
                   TreningId = 2,
                   Naziv = "Pilates",
                   Opis = "Pilates ubrajamo među treninge snage, ali on ne funkcionira kao druge vježbe snage koje možda prakticirate. Pilates se više usredotočuje na poboljšanje tonusa mišića nego na njihovu izgradnju, ali rezultat je sličan: veća stabilnost i izdržljivost mišića. On vam stoga neće izgraditi veliku mišićnu masu, no pomoći će pri oblikovanju vitkijeg izgleda i fit figure. Ipak, i pored toga, pilates može postaviti dobar fizički temelj za aktivnosti koje će vam izgraditi mišiće, pa čak i smanjiti vjerojatnost za nastanak ozljeda.",
                   MaxBrojClanova = 8,
                   CijenaPoTerminu = 3,
                   Trajanje = "40 min",
                   ProsjecnaPotrosnjaKalorija = 250,
                   VrstaId = 1,
                   Namjena = "Fleksibilnost i mobilnost"
               },
               new Treninzi()
               {
                   TreningId = 3,
                   Naziv = "Barbell lift",
                   Opis = "Barbell lift trening fokusira se na vježbe snage s upotrebom šipke (barbell) koja omogućava povećanje težine i progresivno opterećenje. Ovaj trening obuhvaća osnovne vježbe poput čučnjeva, mrtvog dizanja i bench pressa. Pomaže u izgradnji mišićne mase, poboljšanju snage i stabilnosti, te jačanju cijelog tijela. Barbell lift trening je učinkovit za povećanje snage i mišićne izdržljivosti, te je ključan za napredak u mnogim fitness ciljevima. Preporučuje se pravilna tehnika i postupno povećanje težine.",
                   MaxBrojClanova = 10,
                   CijenaPoTerminu = 3,
                   Trajanje = "45 min",
                   ProsjecnaPotrosnjaKalorija = 500,
                   VrstaId = 1,
                   Namjena = "Izgradnja mišića"
               },
               new Treninzi()
               {
                   TreningId = 4,
                   Naziv = "Yoga",
                   Opis = "Yoga trening poboljšava fleksibilnost, snagu i ravnotežu kroz niz kontroliranih položaja i tehnika disanja. Redovita praksa može smanjiti stres, poboljšati mentalnu jasnoću i povećati opću tjelesnu izdržljivost. Yoga nudi različite stilove, od nježnijih poput Hatha yoge, do dinamičnijih kao što je Vinyasa. Ovaj trening je prilagodljiv svim razinama fitnessa i pomaže u postizanju ravnoteže tijela i uma, čime doprinosi cjelokupnom zdravlju i blagostanju.",
                   MaxBrojClanova = 7,
                   CijenaPoTerminu = 3,
                   Trajanje = "45 min",
                   ProsjecnaPotrosnjaKalorija = 150,
                   VrstaId = 1,
                   Namjena = "Fleksibilnost i mobilnost"
               },
               new Treninzi()
               {
                   TreningId = 5,
                   Naziv = "Abs&core",
                   Opis = "Abs&core trening usmjeren je na jačanje mišića trbuha, leđa i zdjelice. Ovaj trening uključuje vježbe poput trbušnjaka, plankova i ruske rotacije koje pomažu u poboljšanju stabilnosti i ravnoteže. Snažan core poboljšava posture, smanjuje rizik od ozljeda i doprinosi boljoj izvedbi u drugim vježbama. Redovitim vježbanjem, možete postići čvrstiju i čvrstiju sredinu tijela, što doprinosi cjelokupnoj tjelesnoj izdržljivosti i funkcionalnoj snazi.",
                   MaxBrojClanova = 10,
                   CijenaPoTerminu = 3,
                   Trajanje = "45 min",
                   ProsjecnaPotrosnjaKalorija = 200,
                   VrstaId = 1,
                   Namjena = "Izgradnja mišića"
               },
               new Treninzi()
               {
                   TreningId = 6,
                   Naziv = "Zumba",
                   Opis = "Zumba je energičan fitness trening koji kombinira ples i aerobne vježbe uz ritmičku glazbu. Svojim dinamičnim i zabavnim pristupom, Zumba pomaže u poboljšanju kardiovaskularne kondicije, koordinacije i fleksibilnosti. Kroz razne plesne stilove poput salse, merenguea i reggaetona, treninzi su motivirajući i omogućuju sagorijevanje velikog broja kalorija. Idealna je za sve razine fitnessa, pruža odličan način za oslobađanje stresa i podizanje raspoloženja.",
                   MaxBrojClanova = 12,
                   CijenaPoTerminu = 3,
                   Trajanje = "60 min",
                   ProsjecnaPotrosnjaKalorija = 550,
                   VrstaId = 1,
                   Namjena = "Kondicija"
               },
               new Treninzi()
               {
                   TreningId = 7,
                   Naziv = "Back health",
                   Opis = "Back health trening usmjeren je na jačanje i stabilizaciju mišića leđa, čime se poboljšava postura i smanjuje rizik od bolova i ozljeda. Ovaj trening uključuje vježbe poput ekstenzija leđa, vuče i planka, koje poboljšavaju fleksibilnost, snagu i ravnotežu mišića leđa. Redovito vježbanje pomaže u održavanju pravilnog držanja tijela, smanjuje napetost i podržava cjelokupno zdravlje kralježnice. Važno je usredotočiti se na pravilnu tehniku kako bi se postigli najbolji rezultati i izbjegle ozljede.",
                   MaxBrojClanova = 6,
                   CijenaPoTerminu = 5,
                   Trajanje = "40 min",
                   ProsjecnaPotrosnjaKalorija = 150,
                   VrstaId = 3,
                   Namjena = "Rehabilitacija i oporavak"
               },
               new Treninzi()
               {
                   TreningId = 8,
                   Naziv = "Advanced",
                   Opis = "Advanced trening je namijenjen iskusnim vježbačima koji traže izazov i želje da unaprijede svoju snagu, izdržljivost i tehniku. Ovaj trening uključuje složene vježbe poput olimpijskih dizanja, visokointenzivnih intervalnih treninga (HIIT) i naprednih varijacija osnovnih vježbi. Fokus je na maksimalnom opterećenju, visokim intenzitetima i specifičnim ciljevima. Pravilna forma i pažljivo planiranje su ključni kako bi se postigli optimalni rezultati i smanjio rizik od ozljeda.",
                   MaxBrojClanova = 7,
                   CijenaPoTerminu = 5,
                   Trajanje = "50 min",
                   ProsjecnaPotrosnjaKalorija = 800,
                   VrstaId = 3,
                   Namjena = "Kondicija"
               },
               new Treninzi()
               {
                   TreningId = 9,
                   Naziv = "Step zumba",
                   Opis = "Step Zumba kombinira elemente Zumba plesnog treninga i step aerobike. Ovaj energičan trening koristi steper za dodavanje visine i intenziteta plesnim rutinama uz ritmičku glazbu. Step Zumba poboljšava kardiovaskularnu kondiciju, koordinaciju i snagu nogu, dok sagorijeva značajan broj kalorija. Dinamične koreografije i varijacije u visini stepera čine trening zabavnim i izazovnim. Idealna je za sve razine fitnessa, pružajući učinkovitu i veselu vježbu koja doprinosi cjelokupnom zdravlju i kondiciji.",
                   MaxBrojClanova = 7,
                   CijenaPoTerminu = 5,
                   Trajanje = "50 min",
                   ProsjecnaPotrosnjaKalorija = 600,
                   VrstaId = 3,
                   Namjena = "Mršavljenje"
               },
               new Treninzi()
               {
                   TreningId = 10,
                   Naziv = "Hatha yoga",
                   Opis = "Hatha yoga je klasičan oblik joge koji se fokusira na osnovne asane (položaje) i tehnike disanja. Ovaj trening pomaže u poboljšanju fleksibilnosti, snage i ravnoteže, te smanjuje stres i napetost. Hatha yoga pruža stabilan temelj za napredovanje u drugim stilovima joge, s naglaskom na usklađivanje disanja i pokreta. Idealna je za sve razine fitnessa, uključujući početnike, i pomaže u uspostavljanju tjelesne i mentalne ravnoteže.",
                   MaxBrojClanova = 5,
                   CijenaPoTerminu = 3,
                   Trajanje = "45 min",
                   ProsjecnaPotrosnjaKalorija = 200,
                   VrstaId = 3,
                   Namjena = "Fleksibilnost i mobilnost"
               },
               new Treninzi()
               {
                   TreningId = 11,
                   Naziv = "Personalni Fit Program",
                   Opis = "Personalizirani individualni trening nudi prilagođeni pristup vježbanju koji se usklađuje s vašim specifičnim ciljevima, potrebama i kondicijskom razinom. Trener kreira jedinstveni plan koji uključuje vježbe, intenzitet i raspored koji odgovara vašim osobnim preferencijama i zdravlju. Ovaj pristup omogućava brže postizanje rezultata, poboljšanje tehnike i maksimalno iskorištavanje vremena provedenog u teretani. Uz stalnu prilagodbu i podršku, personalizirani trening pomaže u ostvarivanju dugoročnih fitness ciljeva na najučinkovitiji način.",
                   MaxBrojClanova = 1,
                   CijenaPoTerminu = 7,
                   Trajanje = "60 min",
                   ProsjecnaPotrosnjaKalorija = 400,
                   VrstaId = 2,
                   Namjena = "Rehabilitacija i oporavak"
               });
        }

        private void SeedVjezbe(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Vjezbe>().HasData(
               new Vjezbe()
               {
                   VjezbaId = 1,
                   Naziv = "Sklek",
                   Opis = "Sklekovi su jedna od najstarijih i najpopularnijih vježbi ikad koja može poboljšati ukupnu kondiciju i snagu. Ova vježba jača prsa, triceps, trup te leđne i trbušne mišiće. Postoje različiti načini za izvođenje ove vježbe: sklekovi sa širokom ili uskim hvatom, s otvorenim dlanovima ili šakama, na ručicama za sklekove, itd."
               },
               new Vjezbe()
               {
                   VjezbaId = 2,
                   Naziv = "Plank",
                   Opis = "Plank je jednostavna vježba koja se može izvoditi bilo kada i bilo gdje. Prvenstveno djeluje na središnji dio tijela, odnosno trbušne i leđne mišiće, no tijekom njezina izvođenja radi cijelo tijelo. Rezultati koji se dobivaju vježbanjem planka lako su vidljivi, a ta vježba poboljšava i držanje tijela te pridonosi općoj dobrobiti za zdravlje."
               },
               new Vjezbe()
               {
                   VjezbaId = 3,
                   Naziv = "Čučanj",
                   Opis = "Čučanj je s pravom poznat kao kralj svih vježbi i ima svoje mjesto u gotovo svakom treningu. Općenito ga karakterizira pokret savijanja koljena i savijanja u kukovima dok leđa ostaju uspravna. Ovaj pokret uglavnom uključuje mišiće donjih udova, kao i središnjeg dijela tijela (core), učinkovito jačajući ta područja."
               },
               new Vjezbe()
               {
                   VjezbaId = 4,
                   Naziv = "Trbušnjaci",
                   Opis = "Ležeći na leđima s nogama savijenim u koljenima i stopalima na tlu, ruke su smještene iza glave ili prekrižene na prsima. Podignite gornji dio tijela prema koljenima, koristeći snagu trbušnih mišića, dok se donji dio tijela i stopala drže na tlu. Trbušnjaci su usmjereni na jačanje gornjih trbušnih mišića, poboljšavajući stabilnost i snagu trupa. Ova vježba pomaže u oblikovanju trbuha, poboljšava držanje i pruža osnovu za druge složenije vježbe."
               },
               new Vjezbe()
               {
                   VjezbaId = 5,
                   Naziv = "Jumping Jacks",
                   Opis = "U ovoj vježbi, počinjete u uspravnom položaju s nogama zajedno i rukama uz tijelo. Skočite tako da raširite noge i ruke u stranu, a zatim se vratite u početni položaj. Skakači poboljšavaju kardiovaskularnu izdržljivost, povećavaju cirkulaciju i sagorijevaju kalorije. Brzi ritam vježbe doprinosi povećanju metabolizma i ukupnoj tjelesnoj kondiciji."
               },
               new Vjezbe()
               {
                   VjezbaId = 6,
                   Naziv = "Marinac (Burpee)",
                   Opis = "Ova složena vježba kombinira čučanj, skakanje i sklek u jednu kontinuiranu aktivnost koja angažira cijelo tijelo. Početni položaj je čučanj, nakon čega slijedi brzi skok u položaj za sklek. Iz izvedbe skleka, vratite se u čučanj i skočite u zrak. Burpees poboljšava snagu, izdržljivost i kardiovaskularnu kondiciju, dok istovremeno sagorijeva značajan broj kalorija i povećava tjelesnu agilnost."
               },
               new Vjezbe()
               {
                   VjezbaId = 7,
                   Naziv = "The Hundred",
                   Opis = "Početni položaj je ležanje na leđima s nogama podignutim u zrak pod kutom od 45 stupnjeva i rukama ispruženim uz tijelo. Podignite glavu i ramena s tla, dok brzo pomičete ruke gore-dolje u malim, brzim pokretima. Ova vježba fokusira se na poboljšanje snage core-a i izdržljivosti, poboljšava cirkulaciju i energizira tijelo. The Hundred je odličan za aktivaciju trbušnih mišića i povećanje opće tjelesne izdržljivosti."
               },
               new Vjezbe()
               {
                   VjezbaId = 8,
                   Naziv = "Single Leg Circle",
                   Opis = "Ležeći na leđima s jednom nogom ispruženom prema stropu, drugu nogu držite ravno na tlu. Polako rotirajte ispruženu nogu u velikim krugovima, pazeći na kontrolu i stabilnost. Ova vježba jača stabilizatore zdjelice i kukova, poboljšava fleksibilnost i cirkulaciju u nogama. Single Leg Circle također pomaže u razvijanju ravnoteže i koordinacije, te omogućuje dublje istezanje mišića."
               },
               new Vjezbe()
               {
                   VjezbaId = 9,
                   Naziv = "Roll Up",
                   Opis = "Ova vježba započinje iz ležećeg položaja s nogama ravno na tlu i rukama ispruženim iznad glave. Polako podižete gornji dio tijela prema nogama, kontrolirajući pokret i angažirajući trbušne mišiće kako biste postigli sjedeći položaj. Nakon toga, polako se spuštate natrag u početni položaj. Roll Up aktivira trbušne mišiće, poboljšava fleksibilnost kralježnice i doprinosi jačanju core-a. Pomaže u poboljšanju posture i omogućava bolju kontrolu nad pokretima."
               },
               new Vjezbe()
               {
                   VjezbaId = 10,
                   Naziv = "Bench press",
                   Opis = "U bench pressu, ležite na klupi s šipkom postavljenom na prsima. Držite šipku s rukama nešto šire od širine ramena, a zatim je polako spuštate prema prsima dok savijate laktove. Nakon toga, gurajte šipku prema gore dok se ruke potpuno ne ispruže. Ova vježba fokusira se na jačanje prsnih mišića, tricepsa i ramena. Bench press pomaže u razvoju gornjeg dijela tijela i snazi gornjih ekstremiteta, te poboljšava ukupnu tjelesnu snagu i stabilnost gornjeg dijela tijela."
               },
               new Vjezbe()
               {
                   VjezbaId = 11,
                   Naziv = "Mrtvo dizanje (Deadlift)",
                   Opis = "U mrtvom dizanju, šipku postavljate na tlo ispred vas, s nogama razdvojenim u širini ramena. Dok savijate koljena i držite leđa ravna, uhvatite šipku s obje ruke i podignite je s tla do uspravnog položaja, koristeći snagu donjeg dijela leđa, stražnjice i nogu. Mrtvo dizanje cilja na donji dio leđa, stražnjicu i noge, poboljšavajući snagu i stabilnost cijelog tijela. Ova vježba također poboljšava grip snagu i angažira mišiće core-a, te doprinosi boljoj funkcionalnoj snazi i posturi."
               },
               new Vjezbe()
               {
                   VjezbaId = 12,
                   Naziv = "Russian Twists",
                   Opis = "Sjedite na tlu s nogama blago savijenim i podignutim od tla. Držite ruke zajedno ispred sebe, a zatim rotirajte trup lijevo-desno, dodirujući tlo s obje strane. Ova vježba cilja na bočne trbušne mišiće, poznate kao obliques, i pomaže u poboljšanju rotacijske snage i stabilnosti. Russian Twists također angažiraju core mišiće, poboljšavajući ukupnu fleksibilnost i ravnotežu trupa."
               },
               new Vjezbe()
               {
                   VjezbaId = 13,
                   Naziv = "Leg Raises",
                   Opis = "Ležeći na leđima s nogama ispruženim i ravnim, polako podižite noge prema stropu, držeći ih ravnima. Nakon što dostignete željeni kut, polako ih spuštajte natrag prema tlu bez da se potpuno dotaknu tla. Leg Raises fokusiraju se na donje trbušne mišiće i poboljšavaju fleksibilnost zdjelice. Ova vježba također pomaže u jačanju core-a, poboljšava stabilnost donjeg dijela trupa i doprinosi cjelokupnom razvoju snage trbuha."
               },
               new Vjezbe()
               {
                   VjezbaId = 14,
                   Naziv = "Reggaeton Jumps",
                   Opis = "Ova vježba uključuje skakanje u skladu s energičnim reggaeton ritmovima, popularnim glazbenim žanrom s Kariba. Skakanje se može izvoditi s varijacijama poput visokih koljena, širokih skokova ili brzih preokreta. Reggaeton Jumps dodaju visoki intenzitet treningu, poboljšavaju snagu nogu i sagorijevaju značajan broj kalorija. Ova vježba doprinosi toniranju nogu, poboljšanju izdržljivosti i cjelokupnoj tjelesnoj kondiciji dok pruža zabavan i energičan način vježbanja."
               },
               new Vjezbe()
               {
                   VjezbaId = 15,
                   Naziv = "Merengue March",
                   Opis = "U ovoj vježbi, koraci su usklađeni s brzim ritmom merenguea, tradicionalnog plesa s Dominikanske Republike. Početni položaj je uspravan, a zatim izvodite brze korake uz pomicanje ruku u ritmu glazbe. Merengue March povećava izdržljivost i poboljšava kardiovaskularnu funkciju, dok istovremeno sagorijeva kalorije. Ova vježba poboljšava ukupnu tjelesnu kondiciju i pomaže u razvijanju ritmičkih sposobnosti i agilnosti."
               },
                new Vjezbe()
                {
                    VjezbaId = 16,
                    Naziv = "Step Knee Lift",
                    Opis = "Početni položaj je s jednom nogom na steperu, dok drugu nogu podižete prema gore u visoki koljenasti lift. Podizanje koljena uz steper aktivira mišiće nogu, stražnjice i core-a. Ova vježba poboljšava tonus mišića, potiče sagorijevanje kalorija i doprinosi boljoj stabilnosti i ravnoteži. Step Knee Lift također pomaže u razvijanju snage i fleksibilnosti nogu, te angažira core mišiće za poboljšanje ukupne tjelesne kondicije."
                },
               new Vjezbe()
               {
                   VjezbaId = 17,
                   Naziv = "Step Touch",
                   Opis = "Ova vježba uključuje korak na steperu, praćen dodirivanjem tla s drugom nogom koja ostaje na steperu. Ovisno o brzini i intenzitetu, Step Touch može uključivati brže dodirivanje tla ili dodavanje pokreta ruku. Ova vježba jača noge, poboljšava stabilnost i povećava otpor, što doprinosi boljem toniranju mišića i jačanju donjeg dijela tijela. Također pomaže u poboljšanju ravnoteže i koordinacije."
               },
               new Vjezbe()
               {
                   VjezbaId = 18,
                   Naziv = "Tree Pose",
                   Opis = "U ovom položaju, stajete na jednu nogu dok drugu nogu postavljate na unutarnju stranu bedra ili potkoljenice, pazeći da ne dodirujete koljeno. Ruke mogu biti ispružene iznad glave ili u položaju molitve pred prsima. Tree Pose poboljšava stabilnost i ravnotežu, aktivira mišiće nogu i core-a, te potiče fokus i mirnoću. Ova vježba pomaže u razvijanju mentalne i fizičke ravnoteže, te doprinosi jačanju donjeg dijela tijela i povećanju fleksibilnosti."
               },
               new Vjezbe()
               {
                   VjezbaId = 19,
                   Naziv = "Warrior Pose",
                   Opis = "Početni položaj uključuje širenje nogu u širini ramena, s jednom nogom ispred i drugom iza, te rukama ispruženim u stranu. Savijate prednje koljeno, držeći stražnju nogu ravno i aktivirate mišiće nogu, stražnjice i core-a. Warrior Pose jača noge, poboljšava ravnotežu i stabilnost, te poboljšava koncentraciju i fokus. Ovaj dinamični položaj također pomaže u otvaranju kukova i povećanju fleksibilnosti."
               },
               new Vjezbe()
               {
                   VjezbaId = 20,
                   Naziv = "Bodyweight Circuits",
                   Opis = "Ovaj krug vježbi bez dodatnog opterećenja koristi vlastitu tjelesnu težinu za treniranje svih glavnih mišićnih skupina. Krug može uključivati vježbe poput sklekova, čučnjeva, trbušnjaka i iskoraka. Bodyweight Circuits pružaju sveukupnu snagu i izdržljivost, prilagođene specifičnim ciljevima i razini fitnessa. Ova vrsta treninga poboljšava mišićnu tonus, kardiovaskularnu izdržljivost i fleksibilnost, te je pogodna za održavanje forme, mršavljenje i jačanje tijela."
               },
               new Vjezbe()
               {
                   VjezbaId = 21,
                   Naziv = "Free Weights Squats",
                   Opis = "Čučnjevi s utezima uključuju držanje slobodnih utega na ramenima ili u rukama dok se spuštate u čučanj. Ova vježba fokusira se na jačanje mišića nogu, stražnjice i core-a. Slobodni utezi omogućuju veće opterećenje i poboljšavaju stabilnost, dok čučnjevi jačaju kvadricepse, hamstrings i gluteus, te potiču ravnotežu i koordinaciju. Ova vježba pomaže u izgradnji snage donjeg dijela tijela i poboljšava funkcionalnu izdržljivost."
               });
        }

        private void SeedOcjene(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Ocjene>().HasData(
                new Ocjene()
                {
                    OcjenaId = 1,
                    Datum = new DateTime(2024, 8, 8),
                    KorisnikId = 1,
                    TrenerId = 1,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 2,
                    Datum = new DateTime(2024, 8, 8),
                    KorisnikId = 1,
                    TrenerId = 2,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 3,
                    Datum = new DateTime(2024, 8, 8),
                    KorisnikId = 1,
                    TrenerId = 5,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 4,
                    Datum = new DateTime(2024, 8, 7),
                    KorisnikId = 2,
                    TrenerId = 3,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 5,
                    Datum = new DateTime(2024, 8, 7),
                    KorisnikId = 2,
                    TrenerId = 2,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 6,
                    Datum = new DateTime(2024, 8, 4),
                    KorisnikId = 2,
                    TrenerId = 5,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 7,
                    Datum = new DateTime(2024, 8, 7),
                    KorisnikId = 3,
                    TrenerId = 3,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 8,
                    Datum = new DateTime(2024, 8, 2),
                    KorisnikId = 4,
                    TrenerId = 4,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 9,
                    Datum = new DateTime(2024, 8, 1),
                    KorisnikId = 5,
                    TrenerId = 5,
                    Ocjena = 3
                },
                new Ocjene()
                {
                    OcjenaId = 10,
                    Datum = new DateTime(2024, 8, 7),
                    KorisnikId = 6,
                    TrenerId = 6,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 11,
                    Datum = new DateTime(2024, 8, 2),
                    KorisnikId = 6,
                    TrenerId = 7,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 12,
                    Datum = new DateTime(2024, 8, 5),
                    KorisnikId = 7,
                    TrenerId = 7,
                    Ocjena = 3
                },
                new Ocjene()
                {
                    OcjenaId = 13,
                    Datum = new DateTime(2024, 8, 9),
                    KorisnikId = 8,
                    TrenerId = 6,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 14,
                    Datum = new DateTime(2024, 8, 9),
                    KorisnikId = 8,
                    TrenerId = 1,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 15,
                    Datum = new DateTime(2024, 8, 12),
                    KorisnikId = 8,
                    TrenerId = 3,
                    Ocjena = 2
                },
                new Ocjene()
                {
                    OcjenaId = 16,
                    Datum = new DateTime(2024, 8, 9),
                    KorisnikId = 9,
                    TrenerId = 5,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 17,
                    Datum = new DateTime(2024, 8, 9),
                    KorisnikId = 9,
                    TrenerId = 2,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 18,
                    Datum = new DateTime(2024, 8, 12),
                    KorisnikId = 9,
                    TrenerId = 7,
                    Ocjena = 4
                },
                new Ocjene()
                {
                    OcjenaId = 19,
                    Datum = new DateTime(2024, 8, 11),
                    KorisnikId = 1,
                    TrenerId = 4,
                    Ocjena = 5
                },
                new Ocjene()
                {
                    OcjenaId = 20,
                    Datum = new DateTime(2024, 8, 10),
                    KorisnikId = 5,
                    TrenerId = 6,
                    Ocjena = 4
                });
        }

        private void SeedClanarine(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Clanarine>().HasData(
                new Clanarine()
                {
                    ClanarinaId = 1,
                    Naziv = "Mjesečna"
                },
                new Clanarine()
                {
                    ClanarinaId = 2,
                    Naziv = "Sedmična"
                },
                new Clanarine()
                {
                    ClanarinaId = 3,
                    Naziv = "Dnevna"
                });
        }

        private void SeedNovosti(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Novosti>().HasData(
               new Novosti()
               {
                   NovostId = 1,
                   Naslov = "Kruzni trening u 16h",
                   Sadrzaj = "Zbog nepredviđenih okolnosti, današnji trening moramo pomjeriti u 16h. Svi koji na trening dolaze u 13h, ako su slobodni, mogu doći na ovaj novi termin. Hvala na razumijevanju!",
                   DatumObjave = new DateTime(2024, 8, 20),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 10,
                   VrstaTreningaId = 1
               },
               new Novosti()
               {
                   NovostId = 2,
                   Naslov = "Pilates u 10h",
                   Sadrzaj = "Izmjena termina.",
                   DatumObjave = new DateTime(2024, 8, 19),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 10,
                   VrstaTreningaId = 1
               },
               new Novosti()
               {
                   NovostId = 3,
                   Naslov = "Kako održati motivaciju tokom ljeta?",
                   Sadrzaj = "Ljeto je savršeno vrijeme za vježbanje na otvorenom i uživanje u aktivnostima na suncu. Međutim, visoke temperature mogu smanjiti vašu motivaciju. Savladajte izazove ljetnog vježbanja uz naše savjete kako održati motivaciju. Preporučujemo rane jutarnje ili kasne večernje treninge kako biste izbjegli najtoplije dijelove dana. Pridružite se našim grupnim vježbama na otvorenom ili isprobajte naše specijalne ljetne fitness izazove koji će vas inspirisati da ostanete aktivni i fit.",
                   DatumObjave = new DateTime(2024, 8, 18),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 10,
                   VrstaTreningaId = null
               },
               new Novosti()
               {
                   NovostId = 4,
                   Naslov = "Novi Grupni Programi",
                   Sadrzaj = "Predstavljamo naše nove grupne programe koji kombinuju snagu, fleksibilnost i zabavu. Naši stručni instruktori vode raznolike grupne treninge kao što su HIIT (visokointenzivni intervalni treninzi), pilates, body pump i još mnogo toga. Grupni treninzi su odličan način da se motivišete uz podršku drugih članova. Ovi programi su dizajnirani da izazovu vaše tijelo i omoguće vam da dostignete svoje fitness ciljeve u dinamičnoj i prijateljskoj atmosferi.",
                   DatumObjave = new DateTime(2024, 8, 15),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 10,
                   VrstaTreningaId = null
               },
               new Novosti()
               {
                   NovostId = 5,
                   Naslov = "Najava nove zaposlenice",
                   Sadrzaj = "Sa velikim zadovoljstvom vas obavještavamo da se našem timu pridružila nova zaposlenica, Medina Turkić. Medina će zauzeti poziciju trenerice i svojim bogatim iskustvom doprinijeti našem centru. Medina je diplomirala na DIF-u, gdje je stekla zvanje magistrice sporta i zdravlja. Uvereni smo da će Medina svojom posvećenošću, entuzijazmom i profesionalizmom značajno doprinijeti našem kolektivu i pomoći nam da postignemo još veće uspjehe. Molimo vas da pružite toplu dobrodošlicu Medini i pomognete joj da se što prije integriše u naš tim. Radujemo se zajedničkom radu i novim postignućima.",
                   DatumObjave = new DateTime(2024, 8, 17),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 10,
                   VrstaTreningaId = 1
               },
               new Novosti()
               {
                   NovostId = 6,
                   Naslov = "Šta jesti prije i posle treninga?",
                   Sadrzaj = "Ishrana je ključna za postizanje i održavanje fitness rezultata. Naš vodič za pravilnu ishranu prije i poslije treninga pomoći će vam da maksimalno iskoristite svoj napor u teretani. Preporučujemo kombinaciju proteina i složenih ugljenih hidrata prije treninga za energiju, dok poslije treninga naglasak stavljamo na brzu apsorpciju proteina kako bismo podržali oporavak mišića i obnovu energije.",
                   DatumObjave = new DateTime(2024, 8, 8),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 10,
                   VrstaTreningaId = null
               },
               new Novosti()
               {
                   NovostId = 7,
                   Naslov = "Savjeti za Sigurno Vježbanje u Centru",
                   Sadrzaj = "Vaša sigurnost je naš prioritet. Nudimo vam savjete kako da vježbate sigurno i efikasno u našem fitness centru. Pravilno zagrijavanje i istezanje prije vježbanja smanjuje rizik od povreda. Takođe, pratite uputstva naših instruktora i koristite opremu prema preporukama kako biste maksimalno iskoristili svaki trening. Naš tim je uvijek tu da vam pruži podršku i odgovori na vaša pitanja.",
                   DatumObjave = new DateTime(2024, 7, 10),
                   IsLiked = false,
                   IsRead = false,
                   BrojLajkova = 0,
                   KorisnikId = 11,
                   VrstaTreningaId = null
               });
        }

        private void SeedKorisnici(ModelBuilder modelBuilder)
        {
            string hash = "lC0njRakwHnzGX84ENFBeKvDvdE=";
            string salt = "7lw6ULAmd2KhTybM2m0/1A==";
            var slikaKorisnika = Convert.FromBase64String("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");
            var slikaAdmina = Convert.FromBase64String("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");

            modelBuilder.Entity<Korisnici>().HasData(
              new Korisnici()
              {
                  KorisnikId = 1,
                  Ime = "Harisa",
                  Prezime = "Poturović",
                  Spol = "Ženski",
                  Telefon = "063448922",
                  Email = "poturovicharisa200@gmail.com",
                  Adresa = "Stolac",
                  DatumRodjenja = new DateTime(2000, 12, 22),
                  DatumPocetkaTreniranja = new DateTime(2024, 5, 20),
                  Visina = "178",
                  Tezina = "70",
                  KorisnickoIme = "mobile",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 2,
                  Ime = "Ena",
                  Prezime = "Balić",
                  Spol = "Ženski",
                  Telefon = "063349522",
                  Email = "enabalic@gmail.com",
                  Adresa = "Mostar",
                  DatumRodjenja = new DateTime(2001, 10, 2),
                  DatumPocetkaTreniranja = new DateTime(2024, 2, 15),
                  Visina = "165",
                  Tezina = "58",
                  KorisnickoIme = "enabalic",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 3,
                  Ime = "Adna",
                  Prezime = "Hadžihasanović",
                  Spol = "Ženski",
                  Telefon = "061342889",
                  Email = "adnah@gmail.com",
                  Adresa = "Mostar",
                  DatumRodjenja = new DateTime(2001, 4, 21),
                  DatumPocetkaTreniranja = new DateTime(2023, 12, 11),
                  Visina = "167",
                  Tezina = "64",
                  KorisnickoIme = "adnah",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 4,
                  Ime = "Nejira",
                  Prezime = "Hasanbegović",
                  Spol = "Ženski",
                  Telefon = "063448991",
                  Email = "nejirah@gmail.com",
                  Adresa = "Ilidža",
                  DatumRodjenja = new DateTime(2001, 8, 12),
                  DatumPocetkaTreniranja = new DateTime(2023, 11, 17),
                  Visina = "168",
                  Tezina = "65",
                  KorisnickoIme = "nejirah",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 5,
                  Ime = "Ajla",
                  Prezime = "Vrače",
                  Spol = "Ženski",
                  Telefon = "061223778",
                  Email = "ajlavrace@gmail.com",
                  Adresa = "Mostar",
                  DatumRodjenja = new DateTime(2001, 3, 23),
                  DatumPocetkaTreniranja = new DateTime(2023, 7, 15),
                  Visina = "168",
                  Tezina = "60",
                  KorisnickoIme = "ajlavrace",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 6,
                  Ime = "Amina",
                  Prezime = "Šahović",
                  Spol = "Ženski",
                  Telefon = "063661723",
                  Email = "aminasahovic@gmail.com",
                  Adresa = "Mostar",
                  DatumRodjenja = new DateTime(2001, 9, 29),
                  DatumPocetkaTreniranja = new DateTime(2022, 1, 26),
                  Visina = "172",
                  Tezina = "67",
                  KorisnickoIme = "aminasahovic",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 7,
                  Ime = "Almedina",
                  Prezime = "Herić",
                  Spol = "Ženski",
                  Telefon = "063623723",
                  Email = "almedinah@gmail.com",
                  Adresa = "Mostar",
                  DatumRodjenja = new DateTime(2001, 9, 14),
                  DatumPocetkaTreniranja = new DateTime(2023, 9, 20),
                  Visina = "172",
                  Tezina = "68",
                  KorisnickoIme = "almedinah",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 8,
                  Ime = "Amnesa",
                  Prezime = "Festić",
                  Spol = "Ženski",
                  Telefon = "061552334",
                  Email = "amnesaf@gmail.com",
                  Adresa = "Stolac",
                  DatumRodjenja = new DateTime(2001, 3, 13),
                  DatumPocetkaTreniranja = new DateTime(2022, 1, 10),
                  Visina = "175",
                  Tezina = "68",
                  KorisnickoIme = "amnesaf",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 9,
                  Ime = "Rijad",
                  Prezime = "Poturović",
                  Spol = "Muški",
                  Telefon = "063448223",
                  Email = "rijadp@gmail.com",
                  Adresa = "Stolac",
                  DatumRodjenja = new DateTime(1998, 12, 21),
                  DatumPocetkaTreniranja = new DateTime(2022, 5, 20),
                  Visina = "193",
                  Tezina = "90",
                  KorisnickoIme = "rijadp",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaKorisnika,
                  UlogaId = 1
              },
              new Korisnici()
              {
                  KorisnikId = 10,
                  Ime = "AdminTest",
                  Prezime = "AdminTest",
                  Spol = "Muški",
                  Telefon = "063431223",
                  Email = "Admin@gmail.com",
                  Adresa = "Stolac",
                  DatumRodjenja = new DateTime(1999, 11, 15),
                  KorisnickoIme = "admin",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaAdmina,
                  UlogaId = 2
              },
              new Korisnici()
              {
                  KorisnikId = 11,
                  Ime = "Admin",
                  Prezime = "Admin",
                  Spol = "Muški",
                  Telefon = "063431223",
                  Email = "Admin2@gmail.com",
                  Adresa = "Stolac",
                  DatumRodjenja = new DateTime(1999, 3, 7),
                  KorisnickoIme = "desktop",
                  LozinkaHash = hash,
                  LozinkaSalt = salt,
                  Slika = slikaAdmina,
                  UlogaId = 2
              });
        }

        private void SeedSale(ModelBuilder modelBuilder)
        {
            var sala1 = Convert.FromBase64String("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");
            var sala2 = Convert.FromBase64String("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");
            modelBuilder.Entity<Sale>().HasData(
                new Sale()
                {
                    SalaId = 1,
                    Naziv = "Sala 1",
                    Velicina = "7x7",
                    Slika = sala1
                },
                new Sale()
                {
                    SalaId = 2,
                    Naziv = "Sala 2",
                    Velicina = "10x10",
                    Slika = sala2
                });
        }

        private void SeedUloge(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Uloge>().HasData(
                new Uloge()
                {
                    UlogaId = 1,
                    Naziv = "Korisnik"
                },
                new Uloge()
                {
                    UlogaId = 2,
                    Naziv = "Administrator"
                });
        }

        private void SeedVrsteTreninga(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<VrsteTreninga>().HasData(
                new VrsteTreninga()
                {
                    VrstaTreningaId = 1,
                    Naziv = "Grupni",
                    Opis = "Grupni trening je dinamičan način vježbanja gdje se okuplja grupa ljudi da bi zajedno učestvovali u planiranom fitnes programu. Tokom treninga, instruktor vodi grupu kroz seriju vježbi koje mogu uključivati kardio, vježbe snage, fleksibilnosti ili kombinaciju svega navedenog."
                },
                new VrsteTreninga()
                {
                    VrstaTreningaId = 2,
                    Naziv = "Individualni",
                    Opis = "Individualni trening je personalizirana fitnes sesija u kojoj trener radi direktno s vama, pružajući potpuni fokus na vaše specifične ciljeve i potrebe. Ova vrsta treninga omogućava vam da dobijete najviše iz svakog treninga kroz prilagođeni plan i individualnu pažnju."
                },
                new VrsteTreninga()
                {
                    VrstaTreningaId = 3,
                    Naziv = "Poluindividualni",
                    Opis = "Poluindividualni trening je specijalan oblik fitnes sesije u kojem trener radi s malom grupom od 2 do 4 osobe, pružajući personalizirani pristup u grupnoj atmosferi. Ova vrsta treninga nudi savršen balans između privatnog i grupnog treninga, omogućavajući vam da ostvarite svoje ciljeve uz podršku trenera i interakciju sa drugima."
                });
        }
        private void SeedTreneri(ModelBuilder modelBuilder)
        {
            var trener = Convert.FromBase64String("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eZ2MJudebecwwvexn54Rie7zbymAIDNYKAzIx5zphiHTm3nsEi8vtwDZdYwBAbsUW5t5zgg2ubwJpbOCAdZ5s05vf122zeDAumCfakc2cJsUZev1xwTKN8EY7p5t7SjBHdW/Cc3f0iWKidhzbudn1HWGKLcFSNifWIdebde8RVPZyi9TPRvwpo1s9RM9uamKB9x+hS5K6uXYaUR1vE7wepQ9G/bhSHQK8zCebN0+h5uxS03yP2BWReh4KwZdjY612fRqWYKlYMObV/Z4DWTg8n6XoqV5Likh2UVhbOzTgdR5nJtwuvOwpRpkLDsFSmEzbd5puCVxHxn9tN2+DweAqsAldNaz95g20Hx6NiZiLztUHoR9aGQeYvlf+dSMIlST1pk26/8AdrJxgEBh1Kw1pg0khMngIthQPfPx6uLu+wu0xoQaFeDzC/D3wuCnYFOJvweRrIk62uTdqFXGtlx+CvjLkYxqCuRS8CQZ7qGcma70xkcLmbvetKEB05e0u/tgII11pqO3Ooc5O9XR+elwC775qIR0+hkoBd+z+lZj3bUZDe77V4dM4EJ3VllSWe53L8UCnyScntWdO2ynsfSHMYqKWz+Kv+arJAduLFdIlQJP3XRgBzXWfFZwN5RQkD69negOmXaBkd2f/gSd3wszqVnQukDSaOhP+6QtHX7FFjPRpAAALAf+7//aAAwDAQACAAMAAAAQ888888888888888888888888888888888888888888888888888888888888888888888888888888888888888w0888xCZ888888888888888888888888888swP98/lJQOQ8888888888888888888888884kIejw0FHc/+888888888888888888888888Zcnm6kF/wC7FlfPPPPPPPPPPPPPPPPPPPPPPN/JHL2Ln/8A/oNzzzzzzzzzzzzzzzzzzzzzzy3z/Tzzwfz/APq888888888888888888888888U/q88888966E088888888888888888888888e/M1zu79Vt/8A30fPPPPPPPPPPPPPPPPPPPPLVP8A/wD83/8A/wD/AP8A/wDynzzzzzzzzzzzzzzzzzzzzz7L3/8A0/8A/wD/AP8A/wD/AN88888888888888888888888N/PT3//AP8A/wD/AP8A/wC8888888888888888888888888r/8A/wD/AP8A/wD/AP088888888888888888888888888c//AP8A/wDoMeK88888888888888888888888888f8A/wD/AP8A/vv0/PPPPPPPPPPPPPPPPPPPPPPPPOHv/wD/AP8A73/wPPPPPPPPPPPPPPPPPPPPPPPPPKdv/wD/AP8A+P8A/wB88888888888888888888888885/8A/wD/AP8A3Pv5fPPPPPPPPPPPPPPPPPPPPPPPPOf/AP8A/wD/APb/AP8A/PPPPPPPPPPPPPPPPPPPPPPPPP8A/wD/AP8A/wDbf/V8888888888888888888888888f/8A/wD/AP8A3lOtPPPPPPPPPPPPPPPPPPPPPPPPPO4NMcv/AOR2zzzzzzzzzzzzzzzzzzzzzzzzzyoIIIIAKPF23zzzzzzzzzzzzzzzzzzzzzzzzwAIIIIIIK39zzzzzzzzzzzzzzzzzzzzzzzzzyAIIIIIIR7/AG8888888888888888888888888CCCSICCFH1W8888888888888888888888888CCCCMCCTx+88888888888888888888888888ACCCgCCS8888888888888888888888888888ICCWyCCC8888888888888888888888888888+CCI4KCG88888888888888888888888888886CCm8oCW08888888888888888888888888886CC08WCC8888888888888888888888888888vOrU88HN0888888888888888888888888888e/uU880/o888888888888888888888888888V/wCvPPPf6PPPPPPPPPPPPPPPPPPPPPPPPPPPN/8ArzzxT/3zzzzzzzzzzzzzzzzzzzzzzzzzzzb/AM888c/M888888888888888888888888887dvc888W/U88888888888888888888888888q/k8888f7e88888888888888888888888887f/AEfPPPMKvPPPPPPPPPPPPPPPPPPPPPPPPOfDpZvPPLFHPPPPPPPPPPPPPPPPPPPPPPPPPEcAjlvPPPuX1PPPPPPPPPPPPPPPPPPPPPPPGpU9nrvPPEQLXPPPPPPPPPPPPPPPPPPPPPPP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");
            var trenerica = Convert.FromBase64String("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");

            modelBuilder.Entity<Treneri>().HasData(
                new Treneri()
                {
                    TrenerId = 1,
                    Ime = "Senad",
                    Prezime = "Ivanković",
                    Spol = "Muški",
                    Telefon = "063333444",
                    Email = "senad@gmail.com",
                    Adresa = "Stolac",
                    DatumZaposlenja = new DateTime(2022, 4, 16),
                    Zvanje = "Magistar sporta i zdravlja",
                    Slika = trener
                },
                new Treneri()
                {
                    TrenerId = 2,
                    Ime = "Medina",
                    Prezime = "Turkić",
                    Spol = "Ženski",
                    Telefon = "062222111",
                    Email = "medina.t@gmail.com",
                    Adresa = "Mostar",
                    DatumZaposlenja = new DateTime(2023, 7, 6),
                    Zvanje = "Diplomirani fizioterapeut",
                    Slika = trenerica
                },
                 new Treneri()
                 {
                     TrenerId = 3,
                     Ime = "Adna",
                     Prezime = "Topuz",
                     Spol = "Ženski",
                     Telefon = "063444555",
                     Email = "adna@gmail.com",
                     Adresa = "Mostar",
                     DatumZaposlenja = new DateTime(2023, 1, 12),
                     Zvanje = "Bachelor sporta i zdravlja",
                     Slika = trenerica
                 },
                  new Treneri()
                  {
                      TrenerId = 4,
                      Ime = "Amna",
                      Prezime = "Topuz",
                      Spol = "Ženski",
                      Telefon = "063456651",
                      Email = "amna@gmail.com",
                      Adresa = "Mostar",
                      DatumZaposlenja = new DateTime(2020, 4, 26),
                      Zvanje = "Magistar kineziologije",
                      Slika = trenerica
                  },
                   new Treneri()
                   {
                       TrenerId = 5,
                       Ime = "Antonia",
                       Prezime = "Ćosić",
                       Spol = "Ženski",
                       Telefon = "061999232",
                       Email = "antonia.cosicc@gmail.com",
                       Adresa = "Mostar",
                       DatumZaposlenja = new DateTime(2023, 8, 20),
                       Zvanje = "Magistar kineziologije",
                       Slika = trenerica
                   },
                   new Treneri()
                   {
                       TrenerId = 6,
                       Ime = "Fatima",
                       Prezime = "Pezić",
                       Spol = "Ženski",
                       Telefon = "063445822",
                       Email = "fatima.p@gmail.com",
                       Adresa = "Mostar",
                       DatumZaposlenja = new DateTime(2022, 12, 2),
                       Zvanje = "Magistar sporta i zdravlja",
                       Slika = trenerica
                   },
                   new Treneri()
                   {
                       TrenerId = 7,
                       Ime = "Katarina",
                       Prezime = "Raguž",
                       Spol = "Ženski",
                       Telefon = "062345332",
                       Email = "katarina@gmail.com",
                       Adresa = "Mostar",
                       DatumZaposlenja = new DateTime(2024, 3, 10),
                       Zvanje = "Magistar kineziologije",
                       Slika = trenerica
                   }
           );
        }
    }
}
