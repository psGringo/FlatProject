using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FlatProject7.Models
{
    public class CounterUpdateHistory
    {
        public int Id { get; set; }
        public DateTime DateTime { get; set; }
        public int OldCounterId { get; set; }
        public int NewCounterId { get; set; }
        public int OldCounterValue { get; set; }
        public int FlatId { get; set; }
    }
}