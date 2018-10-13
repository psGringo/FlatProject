using FlatProject7.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace FlatProject7.Controllers
{
    public class CountersController : Controller
    {
        Db db = new Db();
        public ActionResult Index()
        {
            return View(db.GetCounters());
        }

        [HttpGet]
        public ActionResult CountersToUpdate()
        {
            CountersToUpdateViewModel model = new CountersToUpdateViewModel();
            int selectedValue = 1;
            model.AllStreets = new SelectList(db.GetStreets(), "Id", "Name", selectedValue);
            model.AllHouseNumbers = new SelectList(db.GetHouseNumbers(selectedValue), "Id", "Name");
            model.Flats = db.GetCountersToUpdate("1","1");
            return View(model);
        }        
        [HttpPost]
        public ActionResult CountersToUpdate(CountersToUpdateViewModel model)
        {
            // lists must be loaded again !!!            
            model.AllStreets = new SelectList(db.GetStreets(), "Id", "Name", model.Street.Id);
            model.AllHouseNumbers = new SelectList(db.GetHouseNumbers(model.Street.Id), "Id", "Name");
            model.Flats = db.GetCountersToUpdate(model.Street.Id.ToString(), model.HouseNumber.Id.ToString());            
            return View(model);            
        }
        

        public ActionResult ShowCountersToUpdate()
        {
            var streetIdVal = Request["streetId"];
            var houseNumberIdVal = Request["houseNumberId"];
            return View(db.GetCountersToUpdate(streetIdVal, houseNumberIdVal));
        }

        
        public JsonResult LoadHouseNumbersByStreet(string StreetId)
        {            
            var houseNumbers = db.GetHouseNumbers(Convert.ToInt32(StreetId));
            List<SelectListItem> selectItems = new List<SelectListItem>();
            foreach (HouseNumber hn in houseNumbers)
            {
                selectItems.Add(new SelectListItem { Text = hn.Name, Value = hn.Id.ToString() });
            }            
            return Json(selectItems, JsonRequestBehavior.AllowGet);
        }

        // GET: Counters/Create
        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(Counter Counter)
        {           
            try
            {                
                db.InsertCounter(Counter);
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
                
        public ActionResult Edit(int id)
        {
            return View(db.GetCounter(id));
        }              
    }
}
