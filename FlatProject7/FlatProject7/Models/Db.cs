using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FlatProject7.Models
{
    public class Db
    {
        private string connString = @"Data Source=.\SQLEXPRESS;Initial Catalog=flat_db;Integrated Security=True";
        //
        public IEnumerable<Flat> GetFlats()
        {
            List<Flat> flats = new List<Flat>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("select f.Id as flatID,f.XpathName,c.Id as CounterId, c.SerialNumber from flats f,counters c where f.CounterId=c.Id", conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Flat flat = new Flat();
                    flat.Id = Convert.ToInt32(rdr["flatID"]);
                    flat.XpathName = rdr["XpathName"].ToString();
                    flat.Counter = new Counter();
                    flat.CounterId = Convert.ToInt32(rdr["CounterId"]);
                    flat.Counter.Id = Convert.ToInt32(rdr["CounterId"]);
                    flat.Counter.SerialNumber = rdr["SerialNumber"].ToString();
                    flats.Add(flat);
                }
                conn.Close();
            }
            return flats;
        }
        public IEnumerable<FlatCounterDataViewModel> GetTodayFlats()
        {
            List<FlatCounterDataViewModel> dataList = new List<FlatCounterDataViewModel>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "select f.Id as flatID,f.XpathName,c.Id as CounterId, c.SerialNumber, cd.Value,cd.MeasureDateTime, " + //
                                    "s.Name as Street,hn.Name as HouseNumber,f.FlatNumber " +//
                                    "from flats f,counters c, CounterData cd, streets s, houseNumbers hn " +//
                                    "where f.CounterId = c.Id and cd.CounterId = c.Id " +  //
                                    "and s.Id = hn.StreetId " +
                                    "and hn.Id=f.HouseNumberId "+
                                    "and cd.Id = (select dbo.GetLastCounterDataID(f.Id))";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    FlatCounterDataViewModel fcd = new FlatCounterDataViewModel();
                    // flat
                    fcd.Flat.Id = Convert.ToInt32(rdr["flatID"]);
                    fcd.Flat.XpathName = rdr["XpathName"].ToString();
                    fcd.Flat.Street = rdr["Street"].ToString();
                    fcd.Flat.HouseNumber = rdr["HouseNumber"].ToString();
                    fcd.Flat.FlatNumber = Convert.ToInt32(rdr["flatID"]);
                    // Counter
                    fcd.Counter.Id = Convert.ToInt32(rdr["CounterId"]);
                    fcd.Counter.SerialNumber = rdr["SerialNumber"].ToString();
                    // Counter Data
                    fcd.CounterData.Value = Convert.ToInt32(rdr["Value"]);
                    fcd.CounterData.MeasureDateTime = Convert.ToDateTime(rdr["MeasureDateTime"]);
                    fcd.Counters = new SelectList(GetCounters().ToList(), "Id", "SerialNumber",fcd.Counter.Id);
                    //
                    dataList.Add(fcd);
                }
                conn.Close();
            }
            return dataList;
        }

        
        public IEnumerable<Flat> GetCountersToUpdate(string streetId, string houseNumberId)
        {
            List<Flat> data = new List<Flat>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "select " +
                             "s.Name as Street, " +
                             "hn.Name as HouseNumber, " +
                             "f.FlatNumber, " +
                             "c.SerialNumber " +
                             "from counters c, streets s, houseNumbers hn, flats f " +
                             "where c.Id = f.CounterId " +
                             "and s.Id = @StreetId " +
                             "and " +
                             "hn.Id = @HouseNumberId " +
                             "and "+
                             "f.HouseNumberId=hn.Id "+
                             "and " +
                             "(CAST(NextCheckDate AS DATE) <= (CAST(getdate() AS DATE))) ";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@StreetId", streetId);
                cmd.Parameters.AddWithValue("@HouseNumberId", houseNumberId);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Flat flat = new Flat();
                    flat.Street = rdr["Street"].ToString();
                    flat.HouseNumber = rdr["HouseNumber"].ToString();
                    flat.FlatNumber = Convert.ToInt32(rdr["FlatNumber"]);
                    flat.Counter = new Counter();
                    flat.Counter.SerialNumber = rdr["SerialNumber"].ToString();
                    data.Add(flat);
                }
                conn.Close();
            }
            return data;
        }

        public FlatCounterDataViewModel GetFlatCounterData(int CounterId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "select f.Id as flatId, s.Name as Street,hn.Name as HouseNumber, f.FlatNumber, c.SerialNumber " +
                            "from streets s, houseNumbers hn, flats f, counters c " +
                            "where s.Id = hn.StreetId and f.HouseNumberId = hn.Id and f.CounterId = c.Id and c.Id = @CounterId";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@CounterId", CounterId);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                FlatCounterDataViewModel fcd = new FlatCounterDataViewModel();
                //
                while (rdr.Read())
                {
                    fcd.Flat.Id = Convert.ToInt32(rdr["flatId"]);
                    fcd.Flat.Street = rdr["Street"].ToString();
                    fcd.Flat.HouseNumber = rdr["HouseNumber"].ToString();
                    fcd.Flat.FlatNumber = Convert.ToInt32(rdr["FlatNumber"]);
                    fcd.Counter.Id = CounterId;
                    fcd.Counter.SerialNumber = rdr["SerialNumber"].ToString();
                }
                return fcd;
            }
        }

        public IEnumerable<FlatCounterDataViewModel>  GetFlatAndCounters(int CounterId)
        {
            List<FlatCounterDataViewModel> dataList = new List<FlatCounterDataViewModel>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "select f.Id as flatID,f.XpathName,c.Id as CounterId, c.SerialNumber, cd.Value,cd.MeasureDateTime, " + //
                                    "s.Name as Street,hn.Name as HouseNumber,f.FlatNumber " +//
                                    "from flats f,counters c, CounterData cd, streets s, houseNumbers hn " +//
                                    "where f.CounterId = c.Id and cd.CounterId = c.Id " +  //
                                    "and s.Id = hn.StreetId " +
                                    "and cd.Id = (select dbo.GetLastCounterDataID(f.Id))";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    FlatCounterDataViewModel fcd = new FlatCounterDataViewModel();
                    // flat
                    fcd.Flat.Id = Convert.ToInt32(rdr["flatID"]);
                    fcd.Flat.XpathName = rdr["XpathName"].ToString();
                    fcd.Flat.Street = rdr["Street"].ToString();
                    fcd.Flat.HouseNumber = rdr["HouseNumber"].ToString();
                    fcd.Flat.FlatNumber = Convert.ToInt32(rdr["flatID"]);
                    // Counter
                    fcd.Counter.Id = Convert.ToInt32(rdr["CounterId"]);
                    fcd.Counter.SerialNumber = rdr["SerialNumber"].ToString();
                    // Counter Data
                    fcd.CounterData.Value = Convert.ToInt32(rdr["Value"]);
                    fcd.CounterData.MeasureDateTime = Convert.ToDateTime(rdr["MeasureDateTime"]);
                    //
                    dataList.Add(fcd);
                }
                conn.Close();
            }
            return dataList;
        }

        public int GetLastValueOfCounter(int flatId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "select dbo.GetLastCounterData(@flatId) as lastValue";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@flatId", flatId);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                int result = -1;
                while (rdr.Read())
                {
                    result = Convert.ToInt32(rdr["lastValue"]);
                }
                return result;
            }

        }
        public int InsertCounterData(int CounterId, int Value)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlConnection con = new SqlConnection(connString);
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.CommandText = "INSERT INTO CounterData (CounterId, Value) VALUES(@CounterId, @Value); ";
                cmd.Parameters.AddWithValue("@CounterId", CounterId);
                cmd.Parameters.AddWithValue("@Value", Value);
                int res = cmd.ExecuteNonQuery();
                con.Close();
                return res;
            }
        }

        public int UpdateFlatCounter(int FlatId, int CounterId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlConnection con = new SqlConnection(connString);
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                
                cmd.CommandText = "Update flats Set CounterId=@CounterId where Id=@FlatId";
                cmd.Parameters.AddWithValue("@CounterId", CounterId );
                cmd.Parameters.AddWithValue("@FlatId", FlatId);
                
                int res = cmd.ExecuteNonQuery();
                con.Close();
                return res;
            }
        }
        // --- HISTORY OF UPDATING COUNTERS  
        public int InsertHistory(int OldCounterId, int NewCounterId,int FlatId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlConnection con = new SqlConnection(connString);
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.CommandText = "Insert into countersUpdateHistory " +
                    "(OldCounterId,NewCounterId, OldCounterValue, FlatId) " +
                    "Values (@OldCounterId,@NewCounterId, (select top 1 value from CounterData where CounterId=@OldCounterId order by id desc),@FlatId)";
                cmd.Parameters.AddWithValue("@OldCounterId", OldCounterId);
                cmd.Parameters.AddWithValue("@NewCounterId", NewCounterId);
                cmd.Parameters.AddWithValue("@FlatId", FlatId);

                int res = cmd.ExecuteNonQuery();
                con.Close();
                return res;
            }
        }

        public IEnumerable<CounterUpdateHistory> GetUpdateCountersHistory(int FlatId)
        {
            List<CounterUpdateHistory> histories = new List<CounterUpdateHistory>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("select*from countersUpdateHistory where FlatId=@FlatId order by id desc", conn);
                cmd.Parameters.AddWithValue("@FlatId", FlatId);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    CounterUpdateHistory model = new CounterUpdateHistory();
                    model.Id = Convert.ToInt32(rdr["Id"]);
                    model.FlatId = FlatId;
                    model.NewCounterId = Convert.ToInt32(rdr["NewCounterId"]);
                    model.OldCounterId = Convert.ToInt32(rdr["OldCounterId"]);
                    model.OldCounterValue = Convert.ToInt32(rdr["OldCounterValue"]);
                    model.DateTime = Convert.ToDateTime(rdr["DateTime"]);
                    //
                    histories.Add(model);
                }
                conn.Close();
            }
            return histories;
        }

        // --- COUNTERS
        public IEnumerable<Counter> GetCounters()
        {
            List<Counter> counters = new List<Counter>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("select*from counters", conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {                    
                    Counter counter = new Counter();
                    counter.Id = Convert.ToInt32(rdr["Id"]);
                    counter.SerialNumber = rdr["SerialNumber"].ToString();
                    if (rdr["LastCheckDate"] != DBNull.Value)
                    {
                       counter.LastCheckDate=Convert.ToDateTime(rdr["LastCheckDate"]);
                    }
                    else counter.LastCheckDate = null;
                    if (rdr["NextCheckDate"] != DBNull.Value)
                    {
                        counter.NextCheckDate=Convert.ToDateTime(rdr["NextCheckDate"]);
                    }
                    else counter.NextCheckDate = null;
                    
                    counters.Add(counter);
                }
                conn.Close();
            }
            return counters;
        }
        public int InsertCounter(Counter Counter)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlConnection con = new SqlConnection(connString);
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                if (Counter.NextCheckDate != null)
                {
                    cmd.CommandText = "INSERT INTO counters (SerialNumber, NextCheckDate) VALUES(@SerialNumber, @NextCheckDate);";
                    cmd.Parameters.AddWithValue("@SerialNumber", Counter.SerialNumber);
                    cmd.Parameters.AddWithValue("@NextCheckDate", Counter.NextCheckDate);
                }
                else
                {
                    cmd.CommandText = "INSERT INTO counters (SerialNumber) VALUES(@SerialNumber);";
                    cmd.Parameters.AddWithValue("@SerialNumber", Counter.SerialNumber);
                }                
                int res = cmd.ExecuteNonQuery();
                con.Close();
                return res;
            }
        }
        public Counter GetCounter(int Id)
        {
            Counter counter = new Counter();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("select*from counters where Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", Id);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                
                while (rdr.Read())
                {                    
                    counter.Id = Convert.ToInt32(rdr["Id"]);
                    counter.SerialNumber = rdr["SerialNumber"].ToString();
                    if (rdr["LastCheckDate"] != DBNull.Value)
                    {
                        counter.LastCheckDate = Convert.ToDateTime(rdr["LastCheckDate"]);
                    }
                    else counter.LastCheckDate = null;
                    if (rdr["NextCheckDate"] != DBNull.Value)
                    {
                        counter.NextCheckDate = Convert.ToDateTime(rdr["NextCheckDate"]);
                    }
                    else counter.NextCheckDate = null;
                    
                }
                conn.Close();
            }
            return counter;
        }

        public int UpdateCounter(Counter Counter)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlConnection con = new SqlConnection(connString);
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                int res=0;
                if ((Counter.SerialNumber != null) && (Counter.LastCheckDate != null) && (Counter.NextCheckDate != null))
                {
                    cmd.CommandText = "UPDATE counters  set " +
                                     "SerialNumber = @SerialNumber, " +
                                     "LastCheckDate = @LastCheckDate, " +
                                     "NextCheckDate = @NextCheckDate " +
                                     "where counters.Id = @Id ";
                    cmd.Parameters.AddWithValue("@SerialNumber", Counter.SerialNumber);
                    cmd.Parameters.AddWithValue("@LastCheckDate", Counter.LastCheckDate);
                    cmd.Parameters.AddWithValue("@NextCheckDate", Counter.NextCheckDate);
                    cmd.Parameters.AddWithValue("@Id", Counter.Id);
                    res = cmd.ExecuteNonQuery();
                }
                
                /*
                else
                if ((Counter.SerialNumber != null) && (Counter.NextCheckDate != null))
                {
                    cmd.CommandText = "UPDATE counters  set " +
                                      "SerialNumber = @SerialNumber, " +                                      
                                      "NextCheckDate = @NextCheckDate " +
                                      "where counters.Id = @Id ";
                    cmd.Parameters.AddWithValue("@SerialNumber", Counter.SerialNumber);                    
                    cmd.Parameters.AddWithValue("@NextCheckDate", Counter.NextCheckDate);
                    cmd.Parameters.AddWithValue("@Id", Counter.Id);
                    res = cmd.ExecuteNonQuery();
                }
                if ((Counter.SerialNumber != null) && (Counter.LastCheckDate != null))
                {
                    cmd.CommandText = "UPDATE counters  set " +
                                      "SerialNumber = @SerialNumber, " +
                                      "LastCheckDate = @LastCheckDate " +
                                      "where counters.Id = @Id ";
                    cmd.Parameters.AddWithValue("@SerialNumber", Counter.SerialNumber);
                    cmd.Parameters.AddWithValue("@LastCheckDate", Counter.LastCheckDate);
                    cmd.Parameters.AddWithValue("@Id", Counter.Id);
                    res = cmd.ExecuteNonQuery();
                }
                */                
                con.Close();
                return res;
            }
        }
        // --- STREETS
        public IEnumerable<Street> GetStreets()
        {
            List<Street> streets = new List<Street>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("select*from streets", conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Street s = new Street();
                    s.Id = Convert.ToInt32(rdr["Id"]);
                    s.Name = rdr["Name"].ToString();
                    streets.Add(s);
                }
                conn.Close();
            }
            return streets;
        }
        // --- HOUSE NUMBERS
        public IEnumerable<HouseNumber> GetHouseNumbers(int StreetId)
        {
            List<HouseNumber> houseNumbers = new List<HouseNumber>();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("select*from houseNumbers where StreetId=@StreetId", conn);
                cmd.Parameters.AddWithValue("@StreetId", StreetId);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    HouseNumber hn = new HouseNumber();
                    hn.Id = Convert.ToInt32(rdr["Id"]);
                    hn.Name = rdr["Name"].ToString();
                    houseNumbers.Add(hn);
                }
                conn.Close();
            }
            return houseNumbers;
        }
    }
}