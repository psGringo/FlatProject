using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace FlatProject.Models
{
    public class FlatContext : DbContext
    {       
        public DbSet<Flat> Flats { get; set; }
        //public DbSet<Counter> Counters { get; set; }
        public FlatContext() : base("DbConnection")
        { }
    }
}