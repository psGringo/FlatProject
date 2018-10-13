using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FlatProject7.Models
{
    public class HouseNumber
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? StreetId { get; set; }
        public Street Street { get; set; }        
    }
}