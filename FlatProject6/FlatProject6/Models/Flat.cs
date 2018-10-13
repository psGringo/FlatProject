using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace FlatProject6.Models
{
    public class Flat
    {
        [Key]
        public int Id { get; set; }
        public string XpathName { get; set; }
        public int? CounterId { get; set; }
        public Counter Counter { get; set; }        
    }
}