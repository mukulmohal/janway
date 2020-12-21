﻿using System;
using System.Collections.Generic;

namespace JWA.Core.Entities
{
    public partial class RoleClaim
    {
        public int Id { get; set; }
        public Guid RoleId { get; set; }
        public string ClaimType { get; set; }
        public string ClaimValue { get; set; }

        public virtual Role Role { get; set; }
    }
}
