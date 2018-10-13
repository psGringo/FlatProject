using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using FlatProject5.Models;

namespace FlatProject5.Controllers
{
    public class CounterDatasController : Controller
    {
        private FlatContext db = new FlatContext();

        // GET: CounterDatas
        public ActionResult Index()
        {
            return View(db.CounterDatas.ToList());
        }

        // GET: CounterDatas/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CounterData counterData = db.CounterDatas.Find(id);
            if (counterData == null)
            {
                return HttpNotFound();
            }
            return View(counterData);
        }

        // GET: CounterDatas/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: CounterDatas/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,Value,MeasureDateTime,CountersId")] CounterData counterData)
        {
            if (ModelState.IsValid)
            {
                db.CounterDatas.Add(counterData);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(counterData);
        }

        // GET: CounterDatas/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CounterData counterData = db.CounterDatas.Find(id);
            if (counterData == null)
            {
                return HttpNotFound();
            }
            return View(counterData);
        }

        // POST: CounterDatas/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,Value,MeasureDateTime,CountersId")] CounterData counterData)
        {
            if (ModelState.IsValid)
            {
                db.Entry(counterData).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(counterData);
        }

        // GET: CounterDatas/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CounterData counterData = db.CounterDatas.Find(id);
            if (counterData == null)
            {
                return HttpNotFound();
            }
            return View(counterData);
        }

        // POST: CounterDatas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            CounterData counterData = db.CounterDatas.Find(id);
            db.CounterDatas.Remove(counterData);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
