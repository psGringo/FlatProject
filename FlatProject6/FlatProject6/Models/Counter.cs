using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace FlatProject6.Models
{
    public class Counter
    {
        [Key]
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