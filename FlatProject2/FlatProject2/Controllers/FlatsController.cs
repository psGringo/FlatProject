using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using System.Web;
using System.Web.Mvc;
using FlatProject.Models;

namespace FlatProject2.Controllers
{
    public class FlatsController : Controller
    {
        private FlatContext db = new FlatContext();

        // GET: Flats
        public async Task<ActionResult> Index()
        {
            var flats = db.Flats.Include(f => f.Counter);
            return View(await flats.ToListAsync());
        }

        // GET: Flats/Details/5
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Flat flat = await db.Flats.FindAsync(id);
            if (flat == null)
            {
                return HttpNotFound();
            }
            return View(flat);
        }

        // GET: Flats/Create
        public ActionResult Create()
        {
            ViewBag.CounterId = new SelectList(db.Counters, "Id", "SerialNumber");
            return View();
        }

        // POST: Flats/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create([Bind(Include = "Id,XpathName,CounterId")] Flat flat)
        {
            if (ModelState.IsValid)
            {
                db.Flats.Add(flat);
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }

            ViewBag.CounterId = new SelectList(db.Counters, "Id", "SerialNumber", flat.CounterId);
            return View(flat);
        }

        // GET: Flats/Edit/5
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Flat flat = await db.Flats.FindAsync(id);
            if (flat == null)
            {
                return HttpNotFound();
            }
            ViewBag.CounterId = new SelectList(db.Counters, "Id", "SerialNumber", flat.CounterId);
            return View(flat);
        }

        // POST: Flats/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit([Bind(Include = "Id,XpathName,CounterId")] Flat flat)
        {
            if (ModelState.IsValid)
            {
                db.Entry(flat).State = EntityState.Modified;
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }
            ViewBag.CounterId = new SelectList(db.Counters, "Id", "SerialNumber", flat.CounterId);
            return View(flat);
        }

        // GET: Flats/Delete/5
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Flat flat = await db.Flats.FindAsync(id);
            if (flat == null)
            {
                return HttpNotFound();
            }
            return View(flat);
        }

        // POST: Flats/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            Flat flat = await db.Flats.FindAsync(id);
            db.Flats.Remove(flat);
            await db.SaveChangesAsync();
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
