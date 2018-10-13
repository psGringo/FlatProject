using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FlatProject4.Models
{
    public class Counter
    {
        public int Id { get; set; }
        public string SerialNumber { get; set; }
        public DateTime? LastCheckDate { get; set; }
        public DateTime? NextCheckDate { get; set; }
        public ICollection<CounterData> CounterDatas { get; set; }
        public Counter()
        {
            CounterDatas = new List<CounterData>();
        }
    }
}