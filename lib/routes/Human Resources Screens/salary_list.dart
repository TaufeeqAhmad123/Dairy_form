import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Human%20Resources%20Screens/add_salary.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class EmployeeSalary extends StatefulWidget {
  static String id = 'EmployeeSalary';

  @override
  State<EmployeeSalary> createState() => _EmployeeSalaryState();
}

class _EmployeeSalaryState extends State<EmployeeSalary> {

  //Adding Data To Firebase
  final firestore = FirebaseFirestore.instance;


//Deleting Field
  deleteField(String id){
    return firestore.collection('Employee Salary').doc(id).delete();
  }

  String? name;
  String? payDate;
  String? salaryAmount;
  String? additionalAmount;
  String? totalAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Employee Salary'),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Employee Salary').snapshots(),
            builder: (context, snapshot){
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ));
              }
              List<TableRow> employeeSalaryData = [
                TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    children: [
                      StaffListColumn(
                        columnName: 'Name',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Pay Date',
                        fontSize: fontSize,
                      ),

                      StaffListColumn(
                        columnName: 'Salary',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Additions',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Total',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Action',
                        fontSize: fontSize,
                      ),
                    ]),
              ];

              dynamic data = snapshot.data?.docs;
              for(var dataOfSnapshots in data){
                name = dataOfSnapshots.data()['Name'];
                payDate = dataOfSnapshots.data()['Pay Date'];
                salaryAmount = dataOfSnapshots.data()['Salary Amount'];
                additionalAmount = dataOfSnapshots.data()['Additional Amount'];
                totalAmount = dataOfSnapshots.data()['Total Amount'];

                if(dataOfSnapshots.data()['Farm Name'] == Dashboard.farmName)
                  employeeSalaryData.add(TableRow(children: [
                  StaffListColumn(columnName: name),
                  StaffListColumn(columnName: payDate),
                  StaffListColumn(columnName: salaryAmount),
                  StaffListColumn(columnName: additionalAmount),
                  StaffListColumn(columnName: totalAmount),
                  EditAndDeleteButton(
                      onTapDelete: () {
                        setState(() {
                          showDialog(context: context, builder: (
                              BuildContext context) {
                            return AlertDialog(
                              title: Text('Warning!'),
                              content: Text(
                                  'Are you sure you want to delete this information?'),
                              actions: [
                                CustomButton(buttonName: 'Delete', onPressed: () {
                                  Navigator.pop(context);
                                  deleteField(dataOfSnapshots.data()['Name']);
                                  Fluttertoast.showToast(
                                      msg: '${dataOfSnapshots.data()['Name'] +
                                          ' Deleted'}');
                                },),
                                CustomButton(buttonName: 'Cancel', onPressed: () {
                                  Navigator.pop(context);
                                }),
                              ],
                            );
                          });
                        });
                      },
                      onTapEdit: () {
                        AddSalary.editSalary = true;
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return AddSalary(
                            name: dataOfSnapshots.data()['Name'],
                            payDate: dataOfSnapshots.data()['Pay Date'],
                            additionalAmount: dataOfSnapshots.data()['Additional Amount'],
                            salaryAmount: dataOfSnapshots.data()['Salary Amount'],
                            totalAmount: dataOfSnapshots.data()['Total Amount'],
                          );
                        }));
                      }

                  ),
                ]));
              }
              return CustomTableRowDesign(
                  customColumnWidths: {
                    0: FixedColumnWidth(150)
                  },
                  children: employeeSalaryData);
            }),
      ),
    );
  }
}
