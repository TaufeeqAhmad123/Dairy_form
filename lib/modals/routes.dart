
import 'package:flutter/material.dart';
// import 'package:khan_dairy/routes/Catalog/animal_types.dart';
// import 'package:khan_dairy/routes/Catalog/branch.dart';
// import 'package:khan_dairy/routes/Catalog/designation.dart';
// import 'package:khan_dairy/routes/Catalog/food_item.dart';
// import 'package:khan_dairy/routes/Catalog/food_unit.dart';
// import 'package:khan_dairy/routes/Catalog/monitoring_services.dart';
// import 'package:khan_dairy/routes/Catalog/user_type.dart';
// import 'package:khan_dairy/routes/Catalog/vaccines.dart';
import 'package:khan_dairy/routes/Cow%20Feed/add_cow_feed_information.dart';
import 'package:khan_dairy/routes/Cow%20Feed/cow_feed.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_animal_pregnancy_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_routine_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_vaccine_information.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/animal_pregnancy.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/routine_monitor.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/vaccine_monitor.dart';
import 'package:khan_dairy/routes/Cow%20Sale/add_cow_sale_information.dart';
import 'package:khan_dairy/routes/Cow%20Sale/cow_sale.dart';
import 'package:khan_dairy/routes/Cow%20Sale/cow_sale_due_collection.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Farm%20Expense/add_expense_information.dart';
import 'package:khan_dairy/routes/Farm%20Expense/expense_list.dart';
import 'package:khan_dairy/routes/Human Resources Screens/add_user.dart';
import 'package:khan_dairy/routes/Human Resources Screens/staff_list.dart';
import 'package:khan_dairy/routes/Human Resources Screens/user_list1.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/add_salary.dart';
import 'package:khan_dairy/routes/Login%20Registration/Login.dart';
import 'package:khan_dairy/routes/Login%20Registration/forgot_password.dart';
import 'package:khan_dairy/routes/Login%20Registration/main_page.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';
import 'package:khan_dairy/routes/Login%20Registration/verify_email.dart';
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
import 'package:khan_dairy/routes/Milk%20Parlor/sale_milk.dart';
import 'package:khan_dairy/routes/Reports/animal_statistics.dart';
import 'package:khan_dairy/routes/Reports/cow_sale_report.dart';
import 'package:khan_dairy/routes/Reports/employee_salary_report.dart';
import 'package:khan_dairy/routes/Reports/expense_report.dart';
import 'package:khan_dairy/routes/Reports/milk_Collection_report.dart';
import 'package:khan_dairy/routes/Reports/milk_sale_report.dart';
import 'package:khan_dairy/routes/Reports/vaccine_monitor_report.dart';
import 'package:khan_dairy/routes/Settings/user_settings.dart';
import 'package:khan_dairy/routes/Suppliers/add_suppliers.dart';
import 'package:khan_dairy/routes/Suppliers/suppliers_list.dart';


import '../routes/Human Resources Screens/salary_list.dart';

Map<String, Widget Function(BuildContext)> routes = {
  Dashboard.id: (context) => Dashboard(),
  AddUser.id: (context) => AddUser(),
  StaffList.id: (context) => StaffList(),
  UserList.id: (context) => UserList(),
  EmployeeSalary.id: (context) => EmployeeSalary(),
  CollectMilk.id: (context) => CollectMilk(),
  SaleMilk.id: (context) => SaleMilk(),
  CowFeed.id: (context) => CowFeed(),
  RoutineMonitor.id: (context) => RoutineMonitor(),
  AnimalPregnancy.id: (context) => AnimalPregnancy(),
  ExpenseList.id: (context) => ExpenseList(),
  ManageCow.id: (context) => ManageCow(),
  ManageCalf.id: (context) => ManageCalf(),
  ManageStalls.id: (context) => ManageStalls(),
  SuppliersList.id: (context) => SuppliersList(),
  Login.id: (context) => Login(),
  ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
  Registration.id: (context) => Registration(),
  AddSalary.id: (context) => AddSalary(),
  SaleMilk.id: (context) => SaleMilk(),
  CowFeed.id: (context) => CowFeed(),
  VaccineMonitor.id: (context) => VaccineMonitor(),
  AddVaccineInformation.id: (context) => AddVaccineInformation(),
  AddRoutineInformation.id: (context) => AddRoutineInformation(),
  AddAnimalPregnancyInformation.id: (context) => AddAnimalPregnancyInformation(),
  CowSale.id: (context) => CowSale(),
  AddCowSaleInformation.id: (context) => AddCowSaleInformation(),
  AddExpense.id: (context) => AddExpense(),
  AddMilkSale.id: (context) => AddMilkSale(),
  ManageCow.id: (context) => ManageCow(),
  ManageCalf.id: (context) => ManageCalf(),
  ManageStalls.id: (context) => ManageStalls(),
  UserSettings.id: (context) => UserSettings(),
  ExpenseReport.id: (context) => ExpenseReport(),
  MilkCollectionReport.id: (context) => MilkCollectionReport(),
  EmployeeSalaryReport.id: (context) => EmployeeSalaryReport(),
  MilkSaleReport.id: (context) => MilkSaleReport(),
  VaccineMonitorReport.id: (context) => VaccineMonitorReport(),
  CowSaleReport.id: (context) => CowSaleReport(),
  AnimalStatistics.id: (context) => AnimalStatistics(),
  // AnimalTypes.id: (context) => AnimalTypes(),
  // Branch.id: (context) => Branch(),
  // CatalogColors.id: (context) => CatalogColors(),
  // Designation.id: (context) => Designation(),
  // FoodItem.id: (context) => FoodItem(),
  // FoodUnit.id: (context) => FoodUnit(),
  // MonitoringServices.id: (context) => MonitoringServices(),
  // UserType.id: (context) => UserType(),
  // Vaccines.id: (context) => Vaccines(),
  CowSaleDue.id: (context) => CowSaleDue(),
  AddCow.id: (context) => AddCow(),
  AddCalf.id: (context) => AddCalf(),
  AddStall.id: (context) => AddStall(),
  AddMilkCollection.id: (context) => AddMilkCollection(),
  AddSupplier.id: (context) => AddSupplier(),
  MilkSaleDue.id: (context) => MilkSaleDue(),
  AddCowFeedInformation.id: (context) => AddCowFeedInformation(),
  MainPage.id: (context) => MainPage(),
  VarifyEmailScreen.id: (context) => VarifyEmailScreen(),
};