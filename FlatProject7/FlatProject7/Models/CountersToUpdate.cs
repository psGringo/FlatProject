using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FlatProject7.Models
{
    public class CountersToUpdateViewModel
    {                
        public ICollection<Counter> Counters { get; set; }
        public IEnumerable<Flat> Flats { get; set; }
        public Flat Flat { get; set; }
        public Counter Counter { get; set; }
        public SelectList AllStreets { get; set; }
        public Street Street { get; set; }
        public SelectList AllHouseNumbers { get; set; }
        public HouseNumber HouseNumber { get; set; }

        public CountersToUpdateViewModel()
        {
            Counters = new List<Counter>();
            Flats = new List<Flat>();
            Street = new Street();
            HouseNumber = new HouseNumber();
        }
    }
}