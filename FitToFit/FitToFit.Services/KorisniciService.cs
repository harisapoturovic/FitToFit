using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class KorisniciService : BaseCRUDService<Model.Korisnici, Database.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        public KorisniciService(Ib200048Context context, IMapper mapper)
            :base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Korisnici entity, KorisniciInsertRequest insert)
        {
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);


            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override IQueryable<Korisnici> AddInclude(IQueryable<Korisnici> query, KorisniciSearchObject? search = null)
        {
            if (search?.IsOcjeneIncluded == true)
            {
                query = query.Include("Ocjenes");
            }

            if (search?.IsUlogeIncluded == true)
            {
                query = query.Include(x => x.Uloga);
            }

            return base.AddInclude(query, search);
        }

        public override IQueryable<Korisnici> AddFilter(IQueryable<Korisnici> query, KorisniciSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search.Ime))
            {
                filteredQuery = filteredQuery.Where(x => x.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search.Prezime))
            {
                filteredQuery = filteredQuery.Where(x => x.Prezime.Contains(search.Prezime));
            }
            if (!string.IsNullOrWhiteSpace(search.KorisnickoIme))
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnickoIme.Equals(search.KorisnickoIme));
            }
            if (search.IsAdmin==true)
            {
                filteredQuery = filteredQuery.Where(x => x.UlogaId.Equals(2));
            }
            else
            {
                filteredQuery = filteredQuery.Where(x => x.UlogaId.Equals(1));
            }


            return filteredQuery;
        }

        //prije generalizacije
        //public Model.Korisnici Insert(KorisniciInsertRequest request)
        //{
        //    var entity = new Korisnici();
        //    _mapper.Map(request, entity);
        //
        //    entity.LozinkaSalt = GenerateSalt();
        //    entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Password);
        //
        //    _context.Korisnicis.Add(entity);
        //    _context.SaveChanges();
        //
        //    return _mapper.Map<Model.Korisnici>(entity);
        //}

        //public Model.Korisnici Update(int id, KorisniciUpdateRequest request)
        //{
        //    var entity = _context.Korisnicis.Find(id);
        //
        //    _mapper.Map(request, entity);
        //
        //    _context.SaveChanges();
        //
        //    return _mapper.Map<Model.Korisnici>(entity);
        //}
        public async Task<Model.Korisnici> Login(string username, string password)
        {
            var entity = await _context.Korisnicis.Include(u=>u.Uloga).FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return _mapper.Map<Model.Korisnici>(entity);
        }

        public async Task ChangePasswordAsync(KorisniciChangePassword userChangePass)
        {
            var user = await _context.Korisnicis.FindAsync(userChangePass.Id);

            if (user == null)
                throw new($"Korisnik sa ID-em {userChangePass.Id} nije pronađen.");

            if (user.LozinkaHash == GenerateHash(user.LozinkaSalt, userChangePass.Password))
                throw new("Pogrešna lozinka.");

            user.LozinkaSalt = GenerateSalt();
            user.LozinkaHash = GenerateHash(user.LozinkaSalt, userChangePass.NewPassword);

            _context.Update(user);
            await _context.SaveChangesAsync();
        }

        public async Task ChangeUsernameAsync(KorisniciChangeUsername userChangeUsername)
        {
            var user = await _context.Korisnicis.FindAsync(userChangeUsername.Id);

            if (user == null)
                throw new($"Korisnik sa ID-em {userChangeUsername.Id} nije pronađen.");

            if (user.KorisnickoIme != userChangeUsername.Username)
                throw new ("Trenutno korisničko ime je pogrešno.");

            user.KorisnickoIme = userChangeUsername.NewUsername;

            _context.Update(user);
            await _context.SaveChangesAsync();
        }

        public virtual async Task<Model.Korisnici> Insert(KorisniciInsertRequest insert)
        {
            var set = _context.Set<Korisnici>();

            Korisnici entity = _mapper.Map<Korisnici>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            var novosti = _context.Set<Novosti>();
            var korisniciNovosti = _context.Set<KorisniciNovosti>();
            foreach (var item in novosti)
            {
                KorisniciNovosti n = new KorisniciNovosti();
                n.KorisnikId = entity.KorisnikId;
                n.NovostId = item.NovostId;

                korisniciNovosti.Add(n);
            }
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Korisnici>(entity);
        }

        public virtual async Task<Model.Korisnici> Delete(int id)
        {
            var set = _context.Set<Korisnici>();
            var korisniciNovostiSet = _context.Set<KorisniciNovosti>();
            var ocjeneSet = _context.Set<Ocjene>();

            var korisnik = await set.FirstOrDefaultAsync(n => n.KorisnikId == id);

            if (korisnik == null)
            {
                throw new InvalidOperationException("Korisnik nije pronađen");
            }

            var korisniciNovostiList = await korisniciNovostiSet
                .Where(kn => kn.KorisnikId == id)
                .ToListAsync();

            var ocjeneList = await ocjeneSet
                .Where(kn => kn.KorisnikId == id)
                .ToListAsync();

            korisniciNovostiSet.RemoveRange(korisniciNovostiList);
            ocjeneSet.RemoveRange(ocjeneList);

            set.Remove(korisnik);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Korisnici>(korisnik);
        }
    }
}
