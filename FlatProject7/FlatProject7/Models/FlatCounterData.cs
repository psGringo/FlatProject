using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FlatProject7.Models
{
    public class FlatCounterDataViewModel
    {
        public Flat Flat { get; set; }
        public Counter Counter { get; set; }
        public Counter CounterOld { get; set; }
        public CounterData CounterData { get; set; }
        public SelectList Counters { get; set; }
                
        public FlatCounterDataViewModel()
        {
            Flat = new Flat();
            Counter = new Counter();
            CounterOld = new Counter();
            CounterData = new CounterData();            
        }

    }
}