using FlatProject7.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace FlatProject7.Controllers
{
    public class FlatsController : Controller
    {
        Db dbSQL = new Db();
        DbFlatContext db = new DbFlatContext();
        // GET: Flats
        public ActionResult Index()
        {
            int selectedValue = 1;
            SelectList streets = new SelectList(dbSQL.GetStreets(), "Id", "Name", selectedValue);
            ViewBag.Streets = streets;
            SelectList houseNumbers = new SelectList(dbSQL.GetHouseNumbers(selectedValue), "Id", "Name");
            ViewBag.HouseNumbers = houseNumbers;
            return View(dbSQL.GetTodayFlats());
        }
        
   

     
        [HttpGet]
        public ActionResult AddData(int Id)
        {
            //if(CounterId==null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest, "bad params");
            return View(dbSQL.GetFlatCounterData(Id));
        }
        [HttpPost]
        public ActionResult AddData(FlatCounterDataViewModel fcd)
        {
            // save in db
            if (dbSQL.GetLastValueOfCounter(fcd.Flat.Id)>fcd.CounterData.Value)
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest, "new value must be more then previous");            
            dbSQL.InsertCounterData(fcd.Counter.Id,fcd.CounterData.Value);
            return RedirectToAction("Index");            
        }

        [HttpGet]
        public ActionResult UpdateFlatCounter(int FlatId,int CounterId)
        {            
            FlatCounterDataViewModel fcd = new FlatCounterDataViewModel();
            fcd.Flat.Id = FlatId;
            fcd.CounterOld.Id = CounterId;
            fcd.Counters = new SelectList( dbSQL.GetCounters().ToList(), "Id", "SerialNumber", fcd.Counter.Id);
            return View(fcd);
        }
        [HttpPost]
        public ActionResult UpdateFlatCounter(FlatCounterDataViewModel fcd)
        {            
            dbSQL.UpdateFlatCounter(fcd.Flat.Id,fcd.Counter.Id);
            dbSQL.InsertHistory(fcd.CounterOld.Id,fcd.Counter.Id,fcd.Flat.Id);
            return RedirectToAction("Index");
        }

        public ActionResult GetUpdateCountersHistory(int FlatId)
        {            
            return View(dbSQL.GetUpdateCountersHistory(FlatId));
        }

    }
}
