using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FlatProject7.Models
{
    public class Street
    {
        public int Id { get; set; }
        public string Name { get; set; }        
        public ICollection<HouseNumber> HouseNumbers { get; set; }
    }
}