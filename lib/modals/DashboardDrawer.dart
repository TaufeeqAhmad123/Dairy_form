import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import 'package:khan_dairy/routes/Cow%20Feed/add_cow_feed_information.dart';
import 'package:khan_dairy/routes/Cow%20Feed/cow_feed.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_animal_pregnancy_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_routine_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_vaccine_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/animal_pregnancy.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/vaccine_monitor.dart';
import 'package:khan_dairy/routes/Cow%20Sale/add_cow_sale_information.dart';
import 'package:khan_dairy/routes/Cow%20Sale/cow_sale.dart';
import 'package:khan_dairy/routes/Cow%20Sale/cow_sale_due_collection.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Farm%20Expense/add_expense_information.dart';
import 'package:khan_dairy/routes/Farm%20Expense/expense_list.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/add_salary.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/salary_list.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/staff_list.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/user_list1.dart';
import 'package:khan_dairy/routes/Login%20Registration/Login.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';
import 'package:khan_dairy/routes/Management/add_calf.dart';
import 'package:khan_dairy/routes/Management/add_cow.dart';
import 'package:khan_dairy/routes/Management/add_stall.dart';
import 'package:khan_dairy/routes/Management/manage_calf.dart';
import 'package:khan_dairy/routes/Management/manage_cow.dart';
import 'package:khan_dairy/routes/Management/manage_stall.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/add_milk_collection.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/add_milk_sale.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/collect_milk.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/milk_sale_due.dart';
import 'package:khan_dairy/routes/Reports/employee_salary_report.dart';
import 'package:khan_dairy/routes/Reports/expense_report.dart';
import 'package:khan_dairy/routes/Reports/milk_Collection_report.dart';
import 'package:khan_dairy/routes/Reports/milk_sale_report.dart';
import 'package:khan_dairy/routes/Settings/user_settings.dart';
import 'package:khan_dairy/routes/Suppliers/add_suppliers.dart';
import 'package:khan_dairy/routes/Suppliers/suppliers_list.dart';

import '../../constants/constants.dart';
import '../routes/Cow Monitor/routine_monitor.dart';
import '../routes/Human Resources Screens/add_user.dart';
import '../routes/Milk Parlor/sale_milk.dart';
import '../routes/Reports/cow_sale_report.dart';
import '../routes/Reports/vaccine_monitor_report.dart';

class DashboardDrawer extends StatefulWidget {
  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  //Object To Fetch User Image, Name, Number
  UserSettings userSettings = UserSettings();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      )),
    );
  }

  //Header
  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: 50.0,
        ),

        //User Information.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 50.0,
                child: UserSettings.profileImage == null
                    ? Image.asset(
                        'images/dummyImage.png',
                      )
                    : Image.file(
                        File('${UserSettings.profileImage?.path}'),
                      ),
              ),
            ),
            Column(
              children: [
                Text(
                  "${Registration.userName}",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${Registration.phone}",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // Container(
            //     decoration: BoxDecoration(
            //         color: greenColor,
            //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
            //     height: 30.0,
            //     width: 40.0,
            //     child: Center(
            //       child: Text(
            //         'Edit',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ))
          ],
        ),
      );

//Drawer Items
  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          //Dashboard
          SingleLevelTile(
            name: 'Dashboard',
            icon: Icon(FontAwesomeIcons.gaugeHigh),
            color: primaryColor,
            screen: Dashboard.id,
          ),

          //Human Resources
          MultiLevelTile(
            icon: Icon(FontAwesomeIcons.user),
            name: 'Human Resources',
            subLevelTiles: [
              SingleLevelTile(
                name: 'Add User',
                screen: AddUser.id,
              ),
              SingleLevelTile(
                name: 'Staff List',
                screen: StaffList.id,
              ),
              SingleLevelTile(
                name: 'User List',
                screen: UserList.id,
              ),
              SingleLevelTile(
                name: 'Add Salary',
                screen: AddSalary.id,
              ),
              SingleLevelTile(
                  name: 'Employee Salary', screen: EmployeeSalary.id),
            ],
          ),

          //Milk Parlor
          MultiLevelTile(
              icon: Icon(Icons.water_drop_sharp),
              name: 'Milk Parlor',
              subLevelTiles: [
                SingleLevelTile(
                    name: 'Add Milk Collection', screen: AddMilkCollection.id),
                SingleLevelTile(name: 'Collect Milk', screen: CollectMilk.id),
                SingleLevelTile(name: 'Add Milk Sale', screen: AddMilkSale.id),
                SingleLevelTile(name: 'Sale Milk', screen: SaleMilk.id),
                SingleLevelTile(
                  name: 'Milk Sale Due',
                  screen: MilkSaleDue.id,
                )
              ]),

          //Cow Feed
          MultiLevelTile(
              icon: Icon(Icons.restaurant),
              name: 'Cow Feed',
              subLevelTiles: [
                SingleLevelTile(
                    name: 'Add Cow Feed Information',
                    screen: AddCowFeedInformation.id),
                SingleLevelTile(
                    name: 'Cow Feed Information', screen: CowFeed.id),
              ]),

          //Cow Monitor
          MultiLevelTile(
              icon: Icon(Icons.monitor),
              name: 'Cow Monitor',
              subLevelTiles: [
                SingleLevelTile(
                  name: 'Add Routine Information',
                  screen: AddRoutineInformation.id,
                ),
                SingleLevelTile(
                    name: 'Routine Monitor', screen: RoutineMonitor.id),
                SingleLevelTile(
                  name: 'Add Vaccine Information',
                  screen: AddVaccineInformation.id,
                ),
                SingleLevelTile(
                  name: 'Vaccine Monitor',
                  screen: VaccineMonitor.id,
                ),
                SingleLevelTile(
                  name: 'Add Animal Pregnancy Information',
                  screen: AddAnimalPregnancyInformation.id,
                ),
                SingleLevelTile(
                    name: 'Animal Pregnancy', screen: AnimalPregnancy.id),
              ]),
          MultiLevelTile(
              icon: Icon(Icons.money_off),
              name: 'Cow Sale',
              subLevelTiles: [
                SingleLevelTile(
                  name: 'Add Cow Sale',
                  screen: AddCowSaleInformation.id,
                ),
                SingleLevelTile(
                  name: 'Cow Sale',
                  screen: CowSale.id,
                ),
                SingleLevelTile(
                  name: 'Cow Sale Due',
                  screen: CowSaleDue.id,
                ),
              ]),

          //Farm Expense
          MultiLevelTile(
              icon: Icon(FontAwesomeIcons.moneyBill1),
              name: 'Farm Expense',
              subLevelTiles: [
                SingleLevelTile(
                  name: 'Add Farm Expense',
                  screen: AddExpense.id,
                ),
                SingleLevelTile(name: 'Farm Expense', screen: ExpenseList.id),
              ]),

          //Suppliers
          MultiLevelTile(
              icon: Icon(FontAwesomeIcons.users),
              name: 'Suppliers',
              subLevelTiles: [
                SingleLevelTile(
                  name: 'Add Supplier',
                  screen: AddSupplier.id,
                ),
                SingleLevelTile(
                    name: 'Suppliers List', screen: SuppliersList.id),
              ]),

          //Management
          MultiLevelTile(
              icon: Icon(Icons.manage_accounts),
              name: 'Management',
              subLevelTiles: [
                SingleLevelTile(
                  name: 'Add Cow',
                  screen: AddCow.id,
                ),
                SingleLevelTile(name: 'Manage Cow', screen: ManageCow.id),
                SingleLevelTile(
                  name: 'Add Calf',
                  screen: AddCalf.id,
                ),
                SingleLevelTile(name: 'Manage Calf', screen: ManageCalf.id),
                SingleLevelTile(
                  name: 'Add Stall',
                  screen: AddStall.id,
                ),
                SingleLevelTile(name: 'Manage Stalls', screen: ManageStalls.id)
              ]),

          //Catalog
          // MultiLevelTile(
          //     icon: Icon(Icons.apps),
          //     name: 'Catalog',
          //     subLevelTiles: [
          //       // SingleLevelTile(
          //       //   name: 'Branch',
          //       //   screen: Branch.id,
          //       // ),
          //       SingleLevelTile(
          //         name: 'User Type',
          //         screen: UserType.id,
          //       ),
          //       // SingleLevelTile(
          //       //   name: 'Designation',
          //       //   screen: Designation.id,
          //       // ),
          //       SingleLevelTile(
          //         name: 'Catalog Colors',
          //         screen: CatalogColors.id,
          //       ),
          //       SingleLevelTile(
          //         name: 'Animal Type',
          //         screen: AnimalTypes.id,
          //       ),
          //       SingleLevelTile(
          //         name: 'Vaccines',
          //         screen: Vaccines.id,
          //       ),
          //       SingleLevelTile(
          //         name: 'Food Item',
          //         screen: FoodItem.id,
          //       ),
          //       // SingleLevelTile(
          //       //   name: 'Food Unit',
          //       //   screen: FoodUnit.id,
          //       // ),
          //     ]),

          //Reports
          MultiLevelTile(
            icon: Icon(FontAwesomeIcons.chartColumn),
            name: 'Reports',
            subLevelTiles: [
              SingleLevelTile(
                name: 'Expense Report',
                screen: ExpenseReport.id,
              ),
              SingleLevelTile(
                name: 'Employee Salary Report',
                screen: EmployeeSalaryReport.id,
              ),
              SingleLevelTile(
                name: 'Milk Collection Report',
                screen: MilkCollectionReport.id,
              ),
              SingleLevelTile(
                name: 'Milk Sale Report',
                screen: MilkSaleReport.id,
              ),
              SingleLevelTile(
                name: 'Vaccine Monitor Report',
                screen: VaccineMonitorReport.id,
              ),
              SingleLevelTile(
                name: 'Cow Sale Report',
                screen: CowSaleReport.id,
              ),
              // SingleLevelTile(
              //   name: 'Animal Statistics Report',
              //   screen: AnimalStatistics.id,
              // ),
            ],
          ),

          //Settings
          SingleLevelTile(
              name: 'Settings',
              icon: Icon(FontAwesomeIcons.wrench),
              color: primaryColor,
              screen: UserSettings.id),

          //Log Out
          SingleLevelTile(
              name: 'Logout',
              icon: Icon(Icons.logout),
              color: primaryColor,
              screen: Login.id),
        ],
      );
}
