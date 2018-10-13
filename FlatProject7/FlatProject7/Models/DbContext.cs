using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace FlatProject7.Models
{
    public class DbFlatContext:DbContext
    {
        public DbSet<Counter> Counters { get; set; }
        public DbSet<Street> streets { get; set; }
        public DbSet<HouseNumber> HouseNumbers { get; set; }
        public DbFlatContext() : base("DbConnection")
        { }
    }
}