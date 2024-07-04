using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace database_project
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        public string cs = "Host=localhost;Username=postgres;Password=1290347856;Database=Car_Insurance";
        private void button1_Click(object sender, EventArgs e)
        {
            label1.Text = null;
            var con = new NpgsqlConnection(cs);
            con.Open();
            var sql = "SELECT version()";
            var cmd = new NpgsqlCommand(sql, con);
            var version = cmd.ExecuteScalar().ToString();
            cmd.CommandText = "select insurance.contract_code,drivers.fullname as drivers_fullname,clients.fullname,contract_start_date from clients inner join insurance on clients.contract_code=insurance.contract_code inner join drivers on  clients.contract_code=drivers.contract_code WHERE contract_start_date >= date_trunc('month', current_date ) and contract_start_date < date_trunc('month', current_date + interval '1' month); ";
            cmd.ExecuteNonQuery();
            NpgsqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
            {
                label1.Text+=($"  Contract Number {rdr.GetString(0)}  Driver  {rdr.GetString(1)}  Client {rdr.GetString(2)}  Contract start date  {rdr.GetDate(3)} \n ");
            }
            rdr.Close();
            con.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            label1.Text = null;
            var con2 = new NpgsqlConnection(cs);
            con2.Open();
            var sql2 = "SELECT version()";
            var cmd2 = new NpgsqlCommand(sql2, con2);
            var version2 = cmd2.ExecuteScalar().ToString();
            cmd2.CommandText = " select phonenumber1,fullname,insurance.contract_code,contract_end_date from clients inner join insurance on clients.contract_code=insurance.contract_code where insurance.contract_end_date > date_trunc('month', current_date + interval '1' month) and insurance.contract_end_date < date_trunc('month', current_date + interval '2' month)";
            cmd2.ExecuteNonQuery();
            NpgsqlDataReader rdr2 = cmd2.ExecuteReader();
            while (rdr2.Read())
            {
                label1.Text += ($"  Phonenumber {rdr2.GetString(0)}  Client's full name  {rdr2.GetString(1)}  Contract code {rdr2.GetString(2)}  Contract end date  {rdr2.GetDate(3)} \n ");
            }
            rdr2.Close();
            con2.Close();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            label1.Text=null;
            var con3 = new NpgsqlConnection(cs);
            con3.Open();
            var sql3 = "SELECT version()";
            var cmd3 = new NpgsqlCommand(sql3, con3);
            var version3 = cmd3.ExecuteScalar().ToString();
            cmd3.CommandText = "select count (contract_code),insurance_group, case when DATE_PART('year', contract_start_date::date)=2020  then '2020' when  DATE_PART('year', contract_start_date::date)=2019 then '2019' when  DATE_PART('year', contract_start_date::date)=2018 then '2018'  when DATE_PART('year', contract_start_date::date)=2017  then '2017'  when DATE_PART('year', contract_start_date::date)=2016  then '2016' end as contract_start_year from insurance inner join vehicle_category on insurance.categoryid=vehicle_category.categoryid where valid_con=FALSE and DATE_PART('year', contract_start_date::date) >= 2016 group by contract_start_year,insurance_group order by contract_start_year desc; ";
            cmd3.ExecuteNonQuery();
            NpgsqlDataReader rdr3 = cmd3.ExecuteReader();
            while (rdr3.Read())
            {
                label1.Text += ($"  Contract number {rdr3.GetInt32(0)}  Vehicle Category  {rdr3.GetString(1)} Contract Start Year {rdr3.GetString(2)} \n ");
            }
            
            con3.Close();
            rdr3.Close();
        }


        private void button5_Click(object sender, EventArgs e)
        {
            label1.Text = null;
            var con5 = new NpgsqlConnection(cs);
            con5.Open();
            var sql5 = "SELECT version()";
            var cmd5 = new NpgsqlCommand(sql5, con5);
            var version6 = cmd5.ExecuteScalar().ToString();
            cmd5.CommandText = "select sum (TO_NUMBER(con_cost,'L9G999g999.99')),vehicle_category.insurance_group, count (contract_code) from insurance inner join vehicle_category on insurance.categoryid=vehicle_category.categoryid group by vehicle_category.insurance_group ORDER BY COUNT(TO_NUMBER(con_cost,'L9G999g999.99')) DESC;";
            cmd5.ExecuteNonQuery();
            NpgsqlDataReader rdr5 = cmd5.ExecuteReader();
            while (rdr5.Read())
            {
                label1.Text += ($"  Total Profit {rdr5.GetInt32(0)} Insurance Group {rdr5.GetString(1)} Contract Number  {rdr5.GetInt32(2)} \n ");
            }

            con5.Close();
            rdr5.Close();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            label1.Text = null;
            var con6 = new NpgsqlConnection(cs);
            con6.Open();
            var sql6 = "SELECT version()";
            var cmd6 = new NpgsqlCommand(sql6, con6);
            var version6 = cmd6.ExecuteScalar().ToString();
            cmd6.CommandText = "select count(contract_code),avg(TO_NUMBER(con_cost,'L9G999g999.99')) as avg_con_cost,vehicle_category.insurance_group, avg(TO_NUMBER(con_cost,'L9G999g999.99'))*count(contract_code) as total_profit from insurance inner join vehicle_category on insurance.categoryid=vehicle_category.categoryid group by vehicle_category.insurance_group;";
            cmd6.ExecuteNonQuery();
            NpgsqlDataReader rdr6 = cmd6.ExecuteReader();
            while (rdr6.Read())
            {
                label1.Text += ($" Contract Number {rdr6.GetInt32(0)} Average profit {rdr6.GetDouble(1)} Insurance group {rdr6.GetString(2)} Total profit {rdr6.GetDouble(1)} \n ");
            }

            con6.Close();
            rdr6.Close();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            label1.Text = null;
            var con7 = new NpgsqlConnection(cs);
            con7.Open();
            var sql7 = "SELECT version()";
            var cmd7 = new NpgsqlCommand(sql7, con7);
  
            cmd7.CommandText = "select count(contract_code), case when 2021-release_year<=4 then '0-4' when 2021-release_year>=5 and 2021-release_year<=9 then '5-9' when 2021-release_year>=10 and 2021-release_year<=19 then '10-19' else '20+' end as car_age  from vehicles group by car_age ;";
            cmd7.ExecuteNonQuery();
            NpgsqlDataReader rdr7 = cmd7.ExecuteReader();
            while (rdr7.Read())
            {
                label1.Text += ($" Contract percentage {rdr7.GetInt32(0)} % Car Age {rdr7.GetString(1)} \n ");
            }
            rdr7.Close();
            con7.Close();
        }

        private void button8_Click(object sender, EventArgs e)
        {
            label1.Text = null;
            var con8 = new NpgsqlConnection(cs);
            con8.Open();
            var sql8 = "SELECT version()";
            var cmd8 = new NpgsqlCommand(sql8, con8);
            var version6 = cmd8.ExecuteScalar().ToString();
            cmd8.CommandText = "select count(violation_id)*2, case when DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)>=18 and  DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)<=24 then '18-24' when DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)>=25 and  DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)<=49 then '25-49' when DATE_PART('year', CURRENT_DATE)-DATE_PART('year', drivers.birthdate::date)>=50 and  DATE_PART('year', CURRENT_DATE)-DATE_PART('year',drivers.birthdate::date)<=69 then '50-69' else '70+' end as driver_age from caused_by inner join drivers on caused_by.driver=drivers.drivers_license_number group by driver_age ;  ";
            cmd8.ExecuteNonQuery();
            NpgsqlDataReader rdr8 = cmd8.ExecuteReader();
            while (rdr8.Read())
            {
                label1.Text += ($" Contract percentage {rdr8.GetInt32(0)} % Driver Age {rdr8.GetString(1)} \n ");
            }

            con8.Close();
            rdr8.Close();
        }
    }
}
