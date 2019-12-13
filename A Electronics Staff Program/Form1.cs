using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data;
using MySql.Data.MySqlClient;

namespace A_Electronics_Staff_Program
{
    public partial class Form1 : Form
    {
        MySqlConnection connection;
        MySqlCommand command;
        MySqlDataReader reader;

        string connectString = string.Format(@"server=linux.mme.dongguk.edu; user=s2018112552; password=; database=s2018112552; PORT=33060; Charset=utf8;");

        public Form1()
        {
            InitializeComponent();

            panel1.Enabled = true;
            panel1.Visible = true;

            panel2.Enabled = false;
            panel2.Visible = false;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            connection = new MySqlConnection(connectString);

            try
            {
                connection.Open();
                Console.WriteLine("MySql Connection Success");
                NextButton.Enabled = true;
            }
            catch
            {
                Console.WriteLine("MySql Connection Failed");
                infoText.Text = "Connection Failed!";
                connection.Close();
                NextButton.Enabled = false;
            }
        }

        private void NextButton_Click(object sender, EventArgs e)
        {
            panel1.Enabled = false;
            panel1.Visible = false;

            panel2.Enabled = true;
            panel2.Visible = true;

            SetFranchiseNameListComboBox();
            SetFranchiseInfo(null, null);
        }
        private void MySqlReadSample()
        {
            // query
            string str = "";

            using (MySqlConnection conn = new MySqlConnection(connectString))
            {
                conn.Open();

                MySqlCommand command = new MySqlCommand(str, conn);
                MySqlDataReader dr = command.ExecuteReader();


                dr.Close();
                conn.Close();
            }
        }
        private void MySQLWriteSample()
        {
            string str = "";

            using (MySqlConnection conn = new MySqlConnection(connectString))
            {
                conn.Open();

                MySqlCommand command = new MySqlCommand(str, conn);
                command.ExecuteNonQuery();

                conn.Close();
            }
        }

        /////////////////////////////////////////////////////////////////////////////////////////
        // 지점 조회 panel start --------------------------------------------------------------->

        // 지점명 list box를 설정함
        private void SetFranchiseNameListComboBox()
        {
            string query = "SELECT name FROM Franchise;";

            using(MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                franchise_name.Items.Clear();

                List<string> titleList = new List<string>();
                while (reader.Read())
                {
                    titleList.Add(reader["name"].ToString());
                }

                franchise_name.Items.AddRange(titleList.ToArray());
                franchise_name.SelectedIndex = 0;

                // code end -->

                reader.Close();
                connection.Close();
            }
        }

        // 지점명에 맞는 지점 정보, 근무자 정보, 부품 정보를 갱신함
        private void SetFranchiseInfo(object sender, EventArgs e)
        {
            string text = franchise_name.SelectedItem.ToString();

            SetFranchiseInfo(text);
            SetEmployeeInfoInFranchise(text);
            SetComponentInFranchise(text);
            SetServiceInFranchise(text);
        }
        private void SetFranchiseInfo(string franchise_name)
        {
            string query = "SELECT address, phone FROM Franchise WHERE '" + franchise_name + "' = name;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->

                if (reader.Read())
                {
                    string address = reader["address"].ToString();
                    string phone = reader["phone"].ToString();
                    franchise_address.Text = address;
                    franchise_phone.Text = phone;
                }
                else
                {
                    Console.WriteLine("error");
                }

                // code end -->

                reader.Close();
                connection.Close();
            }


        }
        private void SetEmployeeInfoInFranchise(string franchise_name)
        {
            // query
            string query = "SELECT DISTINCT name, rank, birthday, `call`, mail, address, bank, account, date FROM Employee, Affiliation WHERE Affiliation.franchise_code = ( SELECT Franchise.code FROM Franchise WHERE Franchise.name =  '" + franchise_name + "') AND Affiliation.employee_code = Employee.code;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                employeeInFranchise.Rows.Clear();

                int index = 0;
                while(reader.Read())
                {
                    employeeInFranchise.Rows.Add();

                    employeeInFranchise["이름", index].Value = reader["name"].ToString();
                    employeeInFranchise["직급", index].Value = reader["rank"].ToString();
                    employeeInFranchise["생년월일", index].Value = reader["birthday"].ToString().Split(' ')[0];
                    employeeInFranchise["전화번호", index].Value = reader["call"].ToString();
                    employeeInFranchise["이메일", index].Value = reader["mail"].ToString();
                    employeeInFranchise["주소", index].Value = reader["address"].ToString();
                    employeeInFranchise["은행", index].Value = reader["bank"].ToString();
                    employeeInFranchise["계좌번호", index].Value = reader["account"].ToString();
                    employeeInFranchise["입사일", index].Value = reader["date"].ToString().Split(' ')[0];

                    index++;
                }
                // code end -->

                reader.Close();
                connection.Close();
            }
        }
        private void SetComponentInFranchise(string franchise_name)
        {
            // query
            string query = "SELECT DISTINCT Component.name, Component.price, number FROM ComponentList, Component, Franchise WHERE ComponentList.franchise_code = ( SELECT Franchise.code FROM Franchise WHERE Franchise.name = '" + franchise_name + "' ) AND ComponentList.component_code = Component.code;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                componentInFranchise.Rows.Clear();

                int index = 0;
                while (reader.Read())
                {
                    componentInFranchise.Rows.Add();

                    componentInFranchise["부품명", index].Value = reader["name"].ToString();
                    componentInFranchise["가격", index].Value = reader["price"].ToString();
                    componentInFranchise["개수", index].Value = reader["number"].ToString();

                    index++;
                }
                // code end -->

                reader.Close();
                connection.Close();
            }

        }
        private void SetServiceInFranchise(string franchise_name)
        {
            // query
            string query = "SELECT DISTINCT Component.name, Component.price, number FROM ComponentList, Component, Franchise WHERE ComponentList.franchise_code = ( SELECT Franchise.code FROM Franchise WHERE Franchise.name = '" + franchise_name + "' ) AND ComponentList.component_code = Component.code;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                componentInFranchise.Rows.Clear();

                int index = 0;
                while (reader.Read())
                {
                    componentInFranchise.Rows.Add();

                    componentInFranchise["부품명", index].Value = reader["name"].ToString();
                    componentInFranchise["가격", index].Value = reader["price"].ToString();
                    componentInFranchise["개수", index].Value = reader["number"].ToString();

                    index++;
                }
                // code end -->

                reader.Close();
                connection.Close();
            }
        }

        // 지점명 변경
        private void EditFranchiseName(object sender, EventArgs e)
        {
            editFranchiseNameBox.Visible = true;
            editFranchiseNameBox.Enabled = true;
        }
        private void ApplyFranchiseName(object sender, EventArgs e)
        {
            string text = franchiseName.Text;
            if (text.Equals(""))
            {
                franchiseName.Text = franchise_name.SelectedItem.ToString();
                return;
            }

            string query = "UPDATE Franchise SET name = '" + text + "' WHERE Franchise.name = '" + franchise_name.SelectedItem.ToString() + "';";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                command.ExecuteNonQuery();

                connection.Close();
            }

            editFranchiseNameBox.Visible = false;
            editFranchiseNameBox.Enabled = false;

            SetFranchiseNameListComboBox();
            SetFranchiseInfo(null, null);
        }
        private void CancelEditFranchiseName(object sender, EventArgs e)
        {
            editFranchiseNameBox.Visible = false;
            editFranchiseNameBox.Enabled = false;
        }

        // 지점 주소 변경
        private void EditFranchiseAddress(object sender, EventArgs e)
        {
            editFranchiseAddressBox.Visible = true;
            editFranchiseAddressBox.Enabled = true;
        }
        private void ApplyFranchiseAddress(object sender, EventArgs e)
        {
            string text = franchiseAddress.Text;
            if (text.Equals(""))
            {
                franchiseAddress.Text = franchise_address.Text;
                return;
            }

            string query = "UPDATE Franchise SET address = '" + text + "' WHERE Franchise.name = '" + franchise_name.SelectedItem.ToString() + "';";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                command.ExecuteNonQuery();

                connection.Close();
            }

            editFranchiseAddressBox.Visible = false;
            editFranchiseAddressBox.Enabled = false;

            SetFranchiseInfo(null, null);
        }
        private void CancelEditFranchiseAddress(object sender, EventArgs e)
        {
            editFranchiseAddressBox.Visible = false;
            editFranchiseAddressBox.Enabled = false;
        }

        // 지점 전화번호 변경
        private void EditFranchisePhone(object sender, EventArgs e)
        {
            editFranchisePhoneBox.Visible = true;
            editFranchisePhoneBox.Enabled = true;
        }
        private void ApplyFranchisePhone(object sender, EventArgs e)
        {
            string text = franchisePhone.Text;
            if (text.Equals(""))
            {
                franchisePhone.Text = franchise_phone.Text;
                return;
            }

            string query = "UPDATE Franchise SET phone = '" + text + "' WHERE Franchise.name = '" + franchise_name.SelectedItem.ToString() + "';";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                command.ExecuteNonQuery();

                connection.Close();
            }

            editFranchisePhoneBox.Visible = false;
            editFranchisePhoneBox.Enabled = false;

            SetFranchiseInfo(null, null);
        }
        private void CancelEditFranchisePhone(object sender, EventArgs e)
        {
            editFranchisePhoneBox.Visible = false;
            editFranchisePhoneBox.Enabled = false;
        }

        // 지점 조회 panel end --------------------------------------------------------------->
        /////////////////////////////////////////////////////////////////////////////////////////


        /////////////////////////////////////////////////////////////////////////////////////////
        // 직원 조회 panel start --------------------------------------------------------------->

        // 지점명 list box 설정
        private void SetFranchiseNameInEmployeeListComboBox()
        {
            string query = "SELECT name FROM Franchise;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                franchise_list_box.Items.Clear();

                List<string> titleList = new List<string>();
                while (reader.Read())
                {
                    titleList.Add(reader["name"].ToString());
                }

                franchise_list_box.Items.AddRange(titleList.ToArray());
                franchise_list_box.SelectedIndex = 0;

                // code end -->

                reader.Close();
                connection.Close();
            }

            SetEmployeeNameInEmployeeListComboBox();
        }

        // 지점명에 소속된 직원명을 불러와서 list box 설정
        private void SetEmployeeNameInEmployeeListComboBox()
        {
            string text = franchise_list_box.SelectedItem.ToString();
            string query = "SELECT DISTINCT name FROM Employee, Affiliation WHERE Affiliation.franchise_code = ( SELECT Franchise.code FROM Franchise WHERE Franchise.name =  '" + text + "' ) AND Affiliation.employee_code = Employee.code;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                employee_list_box.Items.Clear();

                List<string> titleList = new List<string>();
                while (reader.Read())
                {
                    titleList.Add(reader["name"].ToString());
                }

                employee_list_box.Items.AddRange(titleList.ToArray());
                employee_list_box.SelectedIndex = 0;

                // code end -->

                reader.Close();
                connection.Close();
            }

            SetEmployeeInfoInEmployeeListComboBox();
        }
        private void SetEmployeeInfoInEmployeeListComboBox()
        {
            string text = employee_list_box.SelectedItem.ToString();
            string query = "SELECT rank, birthday, `call`, mail, address, bank, account, date FROM Employee WHERE name = '" + text + "';";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->

                if (reader.Read())
                {
                    rank_text.Text = reader["rank"].ToString();
                    birthday_text.Text = reader["birthday"].ToString().Split(' ')[0];
                    phone_text.Text = reader["call"].ToString();
                    mail_text.Text = reader["mail"].ToString();
                    bank_text.Text = reader["bank"].ToString();
                    address_text_2.Text = reader["address"].ToString();
                    account_text.Text = reader["account"].ToString();
                    date_text.Text = reader["date"].ToString().Split(' ')[0];
                }

                // code end -->

                reader.Close();
                connection.Close();
            }

            SetComponentOrderInEmployee();
            SetServiceHelperInEmployee();
        }
        private void SetComponentOrderInEmployee()
        {
            string name = employee_list_box.SelectedItem.ToString();

            // query
            string query = "SELECT DISTINCT time, Component.name as `component_name`, Franchise.name as `franchise`, ComponentOrderHistory.number FROM Component, ComponentOrderHistory, Franchise WHERE ComponentOrderHistory.employee_code = ( SELECT `code` FROM Employee WHERE Employee.name = '" + name + "' ) AND ComponentOrderHistory.component_code = Component.code AND ComponentOrderHistory.franchise_code = Franchise.code;";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                componentInEmployee.Rows.Clear();

                int index = 0;
                while (reader.Read())
                {
                    componentInEmployee.Rows.Add();

                    componentInEmployee["일시0", index].Value = reader["time"].ToString();
                    componentInEmployee["부품명2", index].Value = reader["component_name"].ToString();
                    componentInEmployee["지점명", index].Value = reader["franchise"].ToString();
                    componentInEmployee["개수2", index].Value = reader["number"].ToString();

                    index++;
                }
                // code end -->

                reader.Close();
                connection.Close();
            }
        }
        private void SetServiceHelperInEmployee()
        {
            string name = employee_list_box.SelectedItem.ToString();

            // query
            string query = "SELECT time, Service.type, Service.way, Customer.name as 'name' FROM Service, Customer WHERE Service.customer_code = Customer.code AND Service.employee_code = ( SELECT Employee.code FROM Employee WHERE Employee.name = '" + name + "');";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                MySqlDataReader reader = command.ExecuteReader();

                // code start -->
                serviceInEmployee.Rows.Clear();

                int index = 0;
                while (reader.Read())
                {
                    serviceInEmployee.Rows.Add();

                    serviceInEmployee["일시2", index].Value = reader["time"].ToString();
                    serviceInEmployee["서비스종류", index].Value = reader["type"].ToString();

                    int way = reader["way"].ToString() == "0" ? 0 : 1;
                    serviceInEmployee["서비스제공", index].Value = way==0? "서비스 센터" : "방문 출장";
                    serviceInEmployee["고객", index].Value = reader["name"].ToString();

                    index++;
                }
                // code end -->

                reader.Close();
                connection.Close();
            }
        }
        private void SetFranchiseInfoInEmployee(object sender, EventArgs e)
        {
            SetEmployeeNameInEmployeeListComboBox();
        }
        private void SetEmployeeInfoInEmployee(object sender, EventArgs e)
        {
            SetEmployeeInfoInEmployeeListComboBox();
        }
        

        // 직급 변경
        private void EditEmployeeRank(object sender, EventArgs e)
        {
            rank_group_box.Visible = true;
            rank_group_box.Enabled = true;
        }
        private void ApplyEmployeeRank(object sender, EventArgs e)
        {
            string name = employee_list_box.SelectedItem.ToString();
            string rank = rank_combo_box.SelectedItem.ToString();

            string query = "UPDATE Employee SET rank =  '"+ rank + "' WHERE name = '" + name + "';";

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                command.ExecuteNonQuery();

                connection.Close();
            }

            rank_group_box.Visible = false;
            rank_group_box.Enabled = false;

            SetEmployeeInfoInEmployee(null, null);
        }
        private void CancelEmployeeRank(object sender, EventArgs e)
        {
            rank_group_box.Visible = false;
            rank_group_box.Enabled = false;
        }

        // 정보 변경창
        private void EditEmployeeBirth(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "생년월일 변경창";
            employee_edit_text.Text = "생년월일 변경";
            employee_edit_input.Text = "";
        }
        private void EditEmployeePhone(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "전화번호 변경창";
            employee_edit_text.Text = "전화번호 변경";
            employee_edit_input.Text = "";
        }
        private void EditEmployeeMail(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "메일 변경창";
            employee_edit_text.Text = "메일 변경";
            employee_edit_input.Text = "";
        }
        private void EditEmployeeBank(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "은행 변경창";
            employee_edit_text.Text = "은행 변경";
            employee_edit_input.Text = "";
        }
        private void EditEmployeeAccount(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "계좌번호 변경창";
            employee_edit_text.Text = "계좌번호 변경";
            employee_edit_input.Text = "";
        }
        private void EditEmployeeAddress(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "주소 변경창";
            employee_edit_text.Text = "주소 변경";
            employee_edit_input.Text = "";
        }
        private void EditEmployeeName(object sender, EventArgs e)
        {
            if (employee_edit_box.Enabled)
                return;

            employee_edit_box.Visible = true;
            employee_edit_box.Enabled = true;

            employee_edit_box.Text = "이름 변경창";
            employee_edit_text.Text = "이름 변경";
            employee_edit_input.Text = "";
        }
        private void ApplyEmployeeEdited(object sender, EventArgs e)
        {
            string type = employee_edit_box.Text.Split(' ')[0];

            string text = employee_edit_input.Text;
            if (text.Equals(""))
            {
                string temp = "";
                switch(type)
                {
                    case "생년월일":
                        temp = birthday_text.Text;
                        break;
                    case "전화번호":
                        temp = phone_text.Text;
                        break;
                    case "메일":
                        temp = mail_text.Text;
                        break;
                    case "은행":
                        temp = bank_text.Text;
                        break;
                    case "계좌번호":
                        temp = account_text.Text;
                        break;
                    case "주소":
                        temp = address_text_2.Text;
                        break;
                    case "이름":
                        temp = employee_list_box.SelectedItem.ToString();
                        break;
                }
                return;
            }

            string query = "UPDATE Employee SET `temp` = '" + text + "' WHERE Employee.name = '" + employee_list_box.SelectedItem.ToString() + "';";

            switch (type)
            {
                case "생년월일":
                    query = query.Replace("temp", "birthday");
                    break;
                case "전화번호":
                    query = query.Replace("temp", "call");
                    break;
                case "메일":
                    query = query.Replace("temp", "mail");
                    break;
                case "은행":
                    query = query.Replace("temp", "bank");
                    break;
                case "계좌번호":
                    query = query.Replace("temp", "account");
                    break;
                case "주소":
                    query = query.Replace("temp", "address");
                    break;
                case "이름":
                    query = query.Replace("temp", "name");
                    break;
            }

            using (MySqlConnection connection = new MySqlConnection(connectString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(query, connection);
                command.ExecuteNonQuery();

                connection.Close();
            }

            employee_edit_box.Visible = false;
            employee_edit_box.Enabled = false;


            if (type.Equals("이름"))
                SetFranchiseInfoInEmployee(null, null);

            ShowEmployeeInfo(null, null);

        }
        private void CancelEmployeeEdited(object sender, EventArgs e)
        {
            employee_list_box.Text = "변경창";
            employee_edit_text.Text = "변경";

            employee_edit_box.Visible = false;
            employee_edit_box.Enabled = false;
        }

        // 직원 조회 panel end --------------------------------------------------------------->
        /////////////////////////////////////////////////////////////////////////////////////////

        // 창 변경 관련
        private void ShowFranchiseInfo(object sender, EventArgs e)
        {
            franchise_box.Visible = true;
            franchise_box.Enabled = true;

            employee_box.Visible = false;
            employee_box.Enabled = false;

            SetFranchiseNameListComboBox();
            SetFranchiseInfo(null, null);
        }
        private void ShowEmployeeInfo(object sender, EventArgs e)
        {
            franchise_box.Visible = false;
            franchise_box.Enabled = false;

            employee_box.Visible = true;
            employee_box.Enabled = true;

            SetFranchiseNameInEmployeeListComboBox();
        }

    }
}
