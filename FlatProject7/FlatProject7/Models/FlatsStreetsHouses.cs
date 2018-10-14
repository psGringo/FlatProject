using FlatProject7.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FlatProject7.Models
{
    public class FlatsStreetsHouses
    {        
        public IEnumerable<FlatCounterDataViewModel> FlatData {get;set;}
        //
        public SelectList AllStreets { get; set; }
        public Street Street { get; set; }
        public SelectList AllHouseNumbers { get; set; }
        public HouseNumber HouseNumber { get; set; }
        public FlatsStreetsHouses()
        {
            FlatData = new List<FlatCounterDataViewModel>();
            Street = new Street();
            HouseNumber = new HouseNumber();
        }
    }
}