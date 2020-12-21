﻿using JWA.Core.CustomEntities;
using JWA.Core.Entities;
using JWA.Core.Interfaces;
using JWA.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace JWA.Infrastructure.Repositories
{
    public class InviteRepository : BaseRepository<Invite>, IInviteRepository
    {
        public InviteRepository(JWAContext context) : base(context)
        { }

        public async Task<Invite> GetByEmail(string email)
        {
            return await _entities.FirstOrDefaultAsync(e => e.Email.ToLower() == email.ToLower());
        }
        public Invite GetByEmailId(string email)
        {
            return _entities.Where(e => e.Email.ToLower() == email.ToLower()).FirstOrDefault();
        }
    }
}
