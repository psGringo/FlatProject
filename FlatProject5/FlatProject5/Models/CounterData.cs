using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FlatProject5.Models
{
    public class CounterData
    {
        public int Id { get; set; }        
        public int? Value { get; set; }
        public DateTime? MeasureDateTime { get; set; }
        public int? CountersId { get; set; }
        public Counter Counter { get; set; }
    }
}