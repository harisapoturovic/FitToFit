using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace FitToFit.Services.Database;

public partial class _200048Context : DbContext
{
    public _200048Context()
    {
    }

    public _200048Context(DbContextOptions<_200048Context> options)
        : base(options)
    {
    }

    public virtual DbSet<Akcije> Akcijes { get; set; }

    public virtual DbSet<AkcijeTreninzi> AkcijeTreninzis { get; set; }

    public virtual DbSet<Clanarine> Clanarines { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<KorisniciNovosti> KorisniciNovostis { get; set; }

    public virtual DbSet<Novosti> Novostis { get; set; }

    public virtual DbSet<Ocjene> Ocjenes { get; set; }

    public virtual DbSet<RezervacijaStavke> RezervacijaStavkes { get; set; }

    public virtual DbSet<Rezervacije> Rezervacijes { get; set; }

    public virtual DbSet<Sale> Sales { get; set; }

    public virtual DbSet<Termini> Terminis { get; set; }

    public virtual DbSet<Treneri> Treneris { get; set; }

    public virtual DbSet<Treninzi> Treninzis { get; set; }

    public virtual DbSet<TreninziClanarine> TreninziClanarines { get; set; }

    public virtual DbSet<TreninziVjezbe> TreninziVjezbes { get; set; }

    public virtual DbSet<Uloge> Uloges { get; set; }

    public virtual DbSet<Vjezbe> Vjezbes { get; set; }

    public virtual DbSet<VrsteTreninga> VrsteTreningas { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        SeedData(modelBuilder);
        modelBuilder.Entity<Akcije>(entity =>
        {
            entity.HasKey(e => e.AkcijaId).HasName("PK__Akcija__3499D633EFF61050");

            entity.ToTable("Akcije");

            entity.Property(e => e.AkcijaId).HasColumnName("AkcijaID");
            entity.Property(e => e.DatumPocetka).HasColumnType("datetime");
            entity.Property(e => e.DatumZavrsetka).HasColumnType("datetime");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.StateMachine).HasMaxLength(50);
        });

        modelBuilder.Entity<AkcijeTreninzi>(entity =>
        {
            entity.HasKey(e => e.AkcijaTreningId).HasName("PK__AkcijeTr__C8E3F84AE22F4CA7");

            entity.ToTable("AkcijeTreninzi");

            entity.HasIndex(e => e.AkcijaId, "IX_AkcijeTreninzi_AkcijaID");

            entity.HasIndex(e => e.TreningId, "IX_AkcijeTreninzi_TreningID");

            entity.Property(e => e.AkcijaTreningId).HasColumnName("AkcijaTreningID");
            entity.Property(e => e.AkcijaId).HasColumnName("AkcijaID");
            entity.Property(e => e.TreningId).HasColumnName("TreningID");

            entity.HasOne(d => d.Akcija).WithMany(p => p.AkcijeTreninzis)
                .HasForeignKey(d => d.AkcijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__AkcijeTre__Akcij__76969D2E");

            entity.HasOne(d => d.Trening).WithMany(p => p.AkcijeTreninzis)
                .HasForeignKey(d => d.TreningId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__AkcijeTre__Treni__778AC167");
        });

        modelBuilder.Entity<Clanarine>(entity =>
        {
            entity.HasKey(e => e.ClanarinaId).HasName("PK__Clanarin__C51E3BB72B076B1B");

            entity.ToTable("Clanarine");

            entity.Property(e => e.ClanarinaId).HasColumnName("ClanarinaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnik__80B06D6170320940");

            entity.ToTable("Korisnici");

            entity.HasIndex(e => e.UlogaId, "IX_Korisnici_UlogaID");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumPocetkaTreniranja).HasColumnType("datetime");
            entity.Property(e => e.DatumRodjenja).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(50);
            entity.Property(e => e.LozinkaHash).HasMaxLength(50);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.Spol).HasMaxLength(50);
            entity.Property(e => e.Telefon).HasMaxLength(50);
            entity.Property(e => e.Tezina).HasMaxLength(50);
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Visina).HasMaxLength(50);

            entity.HasOne(d => d.Uloga).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.UlogaId)
                .HasConstraintName("FK__Korisnici__Uloga__4A8310C6");
        });

        modelBuilder.Entity<KorisniciNovosti>(entity =>
        {
            entity.HasKey(e => e.KorisniciNovostiId).HasName("PK__Korisnic__6213B3FD0E5E5AF9");

            entity.ToTable("KorisniciNovosti");

            entity.HasIndex(e => e.KorisnikId, "IX_KorisniciNovosti_KorisnikID");

            entity.HasIndex(e => e.NovostId, "IX_KorisniciNovosti_NovostID");

            entity.Property(e => e.KorisniciNovostiId).HasColumnName("KorisniciNovostiID");
            entity.Property(e => e.IsLiked)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isLiked");
            entity.Property(e => e.IsRead)
                .HasDefaultValueSql("((0))")
                .HasColumnName("isRead");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.NovostId).HasColumnName("NovostID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisniciNovostis)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Korisnici__Koris__4F47C5E3");

            entity.HasOne(d => d.Novost).WithMany(p => p.KorisniciNovostis)
                .HasForeignKey(d => d.NovostId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Korisnici__Novos__503BEA1C");
        });

        modelBuilder.Entity<Novosti>(entity =>
        {
            entity.HasKey(e => e.NovostId).HasName("PK__Novosti__967A351C04B2801A");

            entity.ToTable("Novosti");

            entity.HasIndex(e => e.KorisnikId, "IX_Novosti_KorisnikID");

            entity.HasIndex(e => e.VrstaTreningaId, "IX_Novosti_VrstaTreningaID");

            entity.Property(e => e.NovostId).HasColumnName("NovostID");
            entity.Property(e => e.DatumObjave).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov).HasMaxLength(100);
            entity.Property(e => e.VrstaTreningaId).HasColumnName("VrstaTreningaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Novostis)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Novosti__Korisni__46B27FE2");

            entity.HasOne(d => d.VrstaTreninga).WithMany(p => p.Novostis)
                .HasForeignKey(d => d.VrstaTreningaId)
                .HasConstraintName("FK__Novosti__VrstaTr__47A6A41B");
        });

        modelBuilder.Entity<Ocjene>(entity =>
        {
            entity.HasKey(e => e.OcjenaId).HasName("PK__Ocjene__DB0CDB47E9B0D880");

            entity.ToTable("Ocjene");

            entity.HasIndex(e => e.KorisnikId, "IX_Ocjene_KorisnikID");

            entity.HasIndex(e => e.TrenerId, "IX_Ocjene_TrenerID");

            entity.Property(e => e.OcjenaId).HasColumnName("OcjenaID");
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.TrenerId).HasColumnName("TrenerID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Ocjenes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ocjene__Korisnik__68487DD7");

            entity.HasOne(d => d.Trener).WithMany(p => p.Ocjenes)
                .HasForeignKey(d => d.TrenerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ocjene__TrenerID__6754599E");
        });

        modelBuilder.Entity<RezervacijaStavke>(entity =>
        {
            entity.HasKey(e => e.RezervacijaStavkeId).HasName("PK__Rezervac__D01610F9786F69C9");

            entity.ToTable("RezervacijaStavke");

            entity.HasIndex(e => e.RezervacijaId, "IX_RezervacijaStavke_RezervacijaID");

            entity.HasIndex(e => e.TerminId, "IX_RezervacijaStavke_TerminID");

            entity.Property(e => e.RezervacijaStavkeId).HasColumnName("RezervacijaStavkeID");
            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.TerminId).HasColumnName("TerminID");

            entity.HasOne(d => d.Rezervacija).WithMany(p => p.RezervacijaStavkes)
                .HasForeignKey(d => d.RezervacijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rezervaci__Rezer__40058253");

            entity.HasOne(d => d.Termin).WithMany(p => p.RezervacijaStavkes)
                .HasForeignKey(d => d.TerminId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rezervaci__Termi__40F9A68C");
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.RezervacijaId).HasName("PK__Rezervac__CABA44FDDEC3DE6A");

            entity.ToTable("Rezervacije");

            entity.HasIndex(e => e.ClanarinaId, "IX_Rezervacije_ClanarinaID");

            entity.HasIndex(e => e.KorisnikId, "IX_Rezervacije_KorisnikID");

            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.ClanarinaId).HasColumnName("ClanarinaID");
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.Iznos).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.StateMachine).HasMaxLength(50);

            entity.HasOne(d => d.Clanarina).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.ClanarinaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rezervaci__Clana__06CD04F7");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rezervaci__Koris__04E4BC85");
        });

        modelBuilder.Entity<Sale>(entity =>
        {
            entity.HasKey(e => e.SalaId).HasName("PK__Sala__0428485A600F011B");

            entity.ToTable("Sale");

            entity.Property(e => e.SalaId).HasColumnName("SalaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Velicina).HasMaxLength(50);
        });

        modelBuilder.Entity<Termini>(entity =>
        {
            entity.HasKey(e => e.TerminId).HasName("PK__Termini__42126CB592978185");

            entity.ToTable("Termini");

            entity.HasIndex(e => e.SalaId, "IX_Termini_SalaID");

            entity.HasIndex(e => e.TrenerId, "IX_Termini_TrenerID");

            entity.HasIndex(e => e.TreningId, "IX_Termini_TreningID");

            entity.Property(e => e.TerminId).HasColumnName("TerminID");
            entity.Property(e => e.Dan).HasMaxLength(50);
            entity.Property(e => e.SalaId).HasColumnName("SalaID");
            entity.Property(e => e.Sat).HasMaxLength(50);
            entity.Property(e => e.TrenerId).HasColumnName("TrenerID");
            entity.Property(e => e.TreningId).HasColumnName("TreningID");

            entity.HasOne(d => d.Sala).WithMany(p => p.Terminis)
                .HasForeignKey(d => d.SalaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Termini__SalaID__02084FDA");

            entity.HasOne(d => d.Trener).WithMany(p => p.Terminis)
                .HasForeignKey(d => d.TrenerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Termini__TrenerI__01142BA1");

            entity.HasOne(d => d.Trening).WithMany(p => p.Terminis)
                .HasForeignKey(d => d.TreningId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Termini__Trening__00200768");
        });

        modelBuilder.Entity<Treneri>(entity =>
        {
            entity.HasKey(e => e.TrenerId).HasName("PK__Trener__ABE1A1324A37E2D0");

            entity.ToTable("Treneri");

            entity.Property(e => e.TrenerId).HasColumnName("TrenerID");
            entity.Property(e => e.DatumZaposlenja).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.Spol).HasMaxLength(50);
            entity.Property(e => e.Telefon).HasMaxLength(50);
        });

        modelBuilder.Entity<Treninzi>(entity =>
        {
            entity.HasKey(e => e.TreningId).HasName("PK__Treninzi__DFF303F1620F8C00");

            entity.ToTable("Treninzi");

            entity.HasIndex(e => e.VrstaId, "IX_Treninzi_VrstaID");

            entity.Property(e => e.TreningId).HasColumnName("TreningID");
            entity.Property(e => e.CijenaPoTerminu).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Namjena).HasMaxLength(50);
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.ProsjecnaPotrosnjaKalorija).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Trajanje).HasMaxLength(50);
            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");

            entity.HasOne(d => d.Vrsta).WithMany(p => p.Treninzis)
                .HasForeignKey(d => d.VrstaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Treninzi__VrstaI__73BA3083");
        });

        modelBuilder.Entity<TreninziClanarine>(entity =>
        {
            entity.HasKey(e => e.TreningClanarinaId).HasName("PK__Treninzi__6F8C55C168A7ED12");

            entity.ToTable("TreninziClanarine");

            entity.HasIndex(e => e.ClanarinaId, "IX_TreninziClanarine_ClanarinaID");

            entity.HasIndex(e => e.VrstaTreningaId, "IX_TreninziClanarine_VrstaTreningaID");

            entity.Property(e => e.TreningClanarinaId).HasColumnName("TreningClanarinaID");
            entity.Property(e => e.ClanarinaId).HasColumnName("ClanarinaID");
            entity.Property(e => e.VrstaTreningaId).HasColumnName("VrstaTreningaID");

            entity.HasOne(d => d.Clanarina).WithMany(p => p.TreninziClanarines)
                .HasForeignKey(d => d.ClanarinaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TreninziC__Clana__7D439ABD");

            entity.HasOne(d => d.VrstaTreninga).WithMany(p => p.TreninziClanarines)
                .HasForeignKey(d => d.VrstaTreningaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VrstaTreninga");
        });

        modelBuilder.Entity<TreninziVjezbe>(entity =>
        {
            entity.HasKey(e => e.TreningVjezbaId).HasName("PK__Treninzi__AC7E6707E7245F04");

            entity.ToTable("TreninziVjezbe");

            entity.HasIndex(e => e.TreningId, "IX_TreninziVjezbe_TreningID");

            entity.HasIndex(e => e.VjezbaId, "IX_TreninziVjezbe_VjezbaID");

            entity.Property(e => e.TreningVjezbaId).HasColumnName("TreningVjezbaID");
            entity.Property(e => e.Trajanje).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TreningId).HasColumnName("TreningID");
            entity.Property(e => e.VjezbaId).HasColumnName("VjezbaID");

            entity.HasOne(d => d.Trening).WithMany(p => p.TreninziVjezbes)
                .HasForeignKey(d => d.TreningId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TreninziV__Treni__0D7A0286");

            entity.HasOne(d => d.Vjezba).WithMany(p => p.TreninziVjezbes)
                .HasForeignKey(d => d.VjezbaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TreninziV__Vjezb__0E6E26BF");
        });

        modelBuilder.Entity<Uloge>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloge__DCAB23EB26526ADC");

            entity.ToTable("Uloge");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<Vjezbe>(entity =>
        {
            entity.HasKey(e => e.VjezbaId).HasName("PK__Vjezbe__F35479FBF18F3163");

            entity.ToTable("Vjezbe");

            entity.Property(e => e.VjezbaId).HasColumnName("VjezbaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<VrsteTreninga>(entity =>
        {
            entity.HasKey(e => e.VrstaTreningaId).HasName("PK__VrstaTre__58161930F0A76573");

            entity.ToTable("VrsteTreninga");

            entity.Property(e => e.VrstaTreningaId).HasColumnName("VrstaTreningaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
