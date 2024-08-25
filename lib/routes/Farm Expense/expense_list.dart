import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Farm%20Expense/add_expense_information.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class ExpenseList extends StatefulWidget {
  static String id = 'ExpenseList';

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Expense List').doc(id).delete();
  }

  String? expenseId;
  String? addedBy;
  String? purpose;
  String? amount;
  String? date;
  String? details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Expense List'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Expense List').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ));
              }
              List<TableRow> stallsList = [
                TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    children: [
                      StaffListColumn(
                        columnName: 'Expense ID',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Expense Purpose',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Details',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Amount',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Date',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Added By',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Action',
                        fontSize: fontSize,
                      ),
                    ]),
              ];

              dynamic data = snapshot.data?.docs;
              for (var dataOfSnapshots in data) {
                expenseId = dataOfSnapshots.data()['Expense ID'];
                addedBy = dataOfSnapshots.data()['Added By'];
                purpose = dataOfSnapshots.data()['Purpose'];
                details = dataOfSnapshots.data()['Details'];
                amount = dataOfSnapshots.data()['Amount'];
                date = dataOfSnapshots.data()['Date'];

                if(dataOfSnapshots.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(children: [
                  StaffListColumn(columnName: expenseId,inContainer: true, containerColor: Colors.blueGrey.shade200,),
                  StaffListColumn(columnName: purpose),
                  StaffListColumn(columnName: details),
                  StaffListColumn(columnName: amount),
                  StaffListColumn(columnName: date),
                  StaffListColumn(columnName: addedBy),
                  EditAndDeleteButton(
                      onTapDelete: () {
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Warning!'),
                              content: Text(
                                  'Are you sure you want to delete this information?'),
                              actions: [
                                CustomButton(
                                  buttonName: 'Delete',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteField(
                                        dataOfSnapshots.data()['Expense ID']);
                                    Fluttertoast.showToast(
                                        msg:
                                        '${dataOfSnapshots.data()['Expense ID'] + ' Deleted'}');
                                  },
                                ),
                                CustomButton(
                                    buttonName: 'Cancel',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ],
                            );
                          });
                    });
                  }, onTapEdit: () {
                    AddExpense.editExpense = true;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return AddExpense(
                            expenseId: dataOfSnapshots.data()['Expense ID'],
                            addedBy: dataOfSnapshots.data()['Added By'],
                            purpose: dataOfSnapshots.data()['Purpose'],
                            details: dataOfSnapshots.data()['Details'],
                            amount: dataOfSnapshots.data()['Amount'],
                            date: dataOfSnapshots.data()['Date'],
                          );
                        }));
                  }),
                ]));
              }
              return CustomTableRowDesign(
                  customColumnWidths: {0: FixedColumnWidth(150)},
                  children: stallsList);
            }),
      ),
    );
  }
}
