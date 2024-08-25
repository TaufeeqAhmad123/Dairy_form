import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddSalary extends StatefulWidget {
  String? name;
  String? payDate;
  String? salaryAmount;
  String? additionalAmount;
  String? totalAmount;

  AddSalary(
      {this.name,
      this.payDate,
      this.totalAmount,
      this.additionalAmount,
      this.salaryAmount});

  static String id = 'AddSalary';
  static bool editSalary = false;

  @override
  State<AddSalary> createState() => _AddSalaryState();
}

class _AddSalaryState extends State<AddSalary> {
  //Text Field Controllers
  final TextEditingController payDateController = TextEditingController();
  final TextEditingController salaryAmountController = TextEditingController();
  final TextEditingController additionalAmountController =
      TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final employeeListController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Staff List Screen
  editData() {
    employeeListController.text = widget.name!;
    payDateController.text = widget.payDate!;
    salaryAmountController.text = widget.salaryAmount!;
    additionalAmountController.text = widget.additionalAmount!;
    totalAmountController.text = widget.totalAmount!;
  }

  @override
  void initState() {
    if (AddSalary.editSalary == true) {
      editData();
    } else {}
    super.initState();
  }

  //Updating Data
  updateData() {
    firestore
      ..collection('Employee Salary').doc(employeeListController.text).update({
        "Pay Date": payDateController.text.trim(),
        'Salary Amount': salaryAmountController.text.trim(),
        "Additional Amount": additionalAmountController.text.trim(),
        "Total Amount": totalAmountController.text.trim(),
      });
    clearFields();
  }

  //Adding Data To Firebase
  final firestore = FirebaseFirestore.instance;

  addData() async {
    print('Adding Data');
    final collection =
        await FirebaseFirestore.instance.collection('Employee Salary');
    collection.doc(employeeListController.text).set({
      'Name': employeeListController.text.trim(),
      'Pay Date': payDateController.text.trim(),
      'Salary Amount': salaryAmountController.text.trim(),
      'Additional Amount': additionalAmountController.text.trim(),
      'Total Amount': totalAmountController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
    clearFields();
  }

  //Clearing Fields
  clearFields() {
    payDateController.clear();
    salaryAmountController.clear();
    additionalAmountController.clear();
    totalAmountController.clear();
    employeeListController.clear();
  }

  //Avoiding Duplicate Data;
  Future<bool> doesEmailExists(String dbEmail) async {
    final QuerySnapshot results = await FirebaseFirestore.instance
        .collection('Employee Salary')
        .where('Name', isEqualTo: employeeListController.text)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = results.docs;
    return documents.length == 1;
  }

//Globar Key For Validation
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AddSalary.editSalary = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Salary'),
        //Button To Add Data To Firebase
        actions: [
          GestureDetector(
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tap To Save Information"),
              ));
            },
            onTap: () async {
              if (key.currentState!.validate()) {
                //If Edit Data is Pressed Update the data.
                if (AddSalary.editSalary == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  // clearFields();
                  AddSalary.editSalary = false;
                }
                //Checking duplicate email.
                //Checking If Data Already Exists
                if (await doesEmailExists(
                    employeeListController.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg:
                          'Salary Already Added For This Employee Please Select Another');
                } else {
                  //Adding Data
                  addData();
                  Fluttertoast.showToast(msg: 'Salary Added Successfully!');
                  // clearFields();
                  setState(() {});
                }
              }
            },
            child: Icon(
              FontAwesomeIcons.check,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  //Employees List
                  MyTypeAhead(
                    hintText: 'Employees',
                      controller: employeeListController,
                      firestore: firestore,
                      validatorText: 'Please Choose Employee!',
                    onTap: () => AddSalary.editSalary == true
                        ? Fluttertoast.showToast(msg: 'Name cannot be Edited!')
                        : null,
                    prefixIcon: Icon(
                      FontAwesomeIcons.userAstronaut,
                      color: greenColor
                    ),
                    suffixOnTap: () => AddSalary.editSalary == false
                        ? employeeListController.clear()
                        : null,
                    onSuggestionSelected: (value) => employeeListController.text = value!,
                    onSuggestionCallback: (value) async {
                      List<String?> employeesList = [];
                      await firestore
                          .collection('Staff List')
                          .where('Farm Name', isEqualTo: Dashboard.farmName)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                            if (doc['Name'].toLowerCase().contains(value)) {
                                employeesList.addAll(
                                    ['${doc['Name']}\n(${doc['Email']})']);

                          }
                        });
                      });
                      return employeesList;
                    },
                  ),
                  //Pay Date
                  dateSelectionTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Choose Pay Date!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Pay Date',
                    calendarDate: payDateController,
                  ),
                  //Salary Amount
                  MyTextField(
                    hintIcon: Icon(
                      FontAwesomeIcons.moneyBill1Wave,
                      color: greenColor,
                    ),
                    numberKeyboard: true,
                    onChanged: (val) {
                      if (salaryAmountController.text.isNotEmpty) {
                        if (additionalAmountController.text.isNotEmpty) {
                          int total =
                              int.parse(additionalAmountController.text) +
                                  int.parse(val);
                          totalAmountController.text = total.toString();
                        } else {
                          totalAmountController.text =
                              salaryAmountController.text;
                        }
                      } else {
                        additionalAmountController.clear();
                        totalAmountController.clear();
                      }
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Salary Amount Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Salary Amount',
                    controller: salaryAmountController,
                  ),
                  //Additional Amount
                  MyTextField(
                    onTap: () {
                      if (salaryAmountController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Add Salary Amount First!');
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        if (additionalAmountController.text.isNotEmpty) {
                          int total = int.parse(salaryAmountController.text) +
                              int.parse(val);
                          totalAmountController.text = total.toString();
                        } else {
                          totalAmountController.text =
                              salaryAmountController.text;
                        }
                      });
                    },
                    hintIcon: Icon(
                      FontAwesomeIcons.moneyBill1Wave,
                      color: greenColor,
                    ),
                    numberKeyboard: true,
                    noKeyboard:
                        salaryAmountController.text.isEmpty ? true : false,
                    hintText: 'Additional Amount',
                    controller: additionalAmountController,
                  ),
                  //Total Amount
                  MyTextField(
                      hintIcon: Icon(
                        FontAwesomeIcons.moneyBill1Wave,
                        color: greenColor,
                      ),
                      noKeyboard: true,
                      onTap: () => Fluttertoast.showToast(
                          msg: "Please Fill Above Fields First"),
                      hintText: 'Total Amount',
                      controller: totalAmountController),
                ],
              )),
        ),
      ),
    );
  }
}

