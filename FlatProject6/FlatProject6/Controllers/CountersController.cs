﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using FlatProject6.Models;

namespace FlatProject6.Controllers
{
    public class CountersController : Controller
    {
        private FlatContext db = new FlatContext();

        // GET: Counters
        public ActionResult Index()
        {
            return View(db.Counters.ToList());
        }

        // GET: Counters/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Counter counter = db.Counters.Find(id);
            if (counter == null)
            {
                return HttpNotFound();
            }
            return View(counter);
        }

        // GET: Counters/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Counters/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,SerialNumber,LastCheckDate,NextCheckDate")] Counter counter)
        {
            if (ModelState.IsValid)
            {
                db.Counters.Add(counter);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(counter);
        }

        // GET: Counters/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Counter counter = db.Counters.Find(id);
            if (counter == null)
            {
                return HttpNotFound();
            }
            return View(counter);
        }

        // POST: Counters/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,SerialNumber,LastCheckDate,NextCheckDate")] Counter counter)
        {
            if (ModelState.IsValid)
            {
                db.Entry(counter).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(counter);
        }

        // GET: Counters/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Counter counter = db.Counters.Find(id);
            if (counter == null)
            {
                return HttpNotFound();
            }
            return View(counter);
        }

        // POST: Counters/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Counter counter = db.Counters.Find(id);
            db.Counters.Remove(counter);
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
