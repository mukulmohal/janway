using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace JWA.Core.Entities
{
    public partial class Organization : BaseEntity
    {
        public Organization()
        {
            Facilities = new HashSet<Facility>();
            Supervisors = new HashSet<Supervisor>();
            Invites = new HashSet<Invite>();
        }
        [Key]
        public int OrganizationId { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public int AddressId { get; set; }
        public DateTime CreationDate { get; set; }

        public virtual Address Address { get; set; }
        public virtual ICollection<Facility> Facilities { get; set; }
        public virtual ICollection<Supervisor> Supervisors { get; set; }
        public virtual ICollection<Invite> Invites { get; set; }
    }
}
