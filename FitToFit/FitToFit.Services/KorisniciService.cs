﻿using AutoMapper;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services.Database;
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
            return base.AddInclude(query, search);
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
    }
}
