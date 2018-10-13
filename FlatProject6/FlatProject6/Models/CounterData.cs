using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FlatProject6.Models
{
    public class CounterData
    {
        public int Id { get; set; }        
        public int? Value { get; set; }
        public DateTime? MeasureDateTime { get; set; }
        public int? CounterId { get; set; }
        public Counter Counter { get; set; }
    }
}