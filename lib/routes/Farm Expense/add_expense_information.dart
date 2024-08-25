import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddExpense extends StatefulWidget {
  String? purpose;
  String? date;
  String? details;
  String? amount;
  String? addedBy;
  String? expenseId;

  AddExpense({this.purpose,
    this.date,
    this.details,
    this.addedBy,
    this.amount,
    this.expenseId});

  static String id = 'AddExpense';
  static bool editExpense = false;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  //Text Field Controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController addedByController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController expenseIdController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Staff List Screen
  editData() {
    purposeController.text = widget.purpose!;
    dateController.text = widget.date!;
    detailsController.text = widget.details!;
    amountController.text = widget.amount!;
    addedByController.text = widget.addedBy!;
    expenseIdController.text = widget.expenseId!;
  }

  @override
  void initState() {
    if (AddExpense.editExpense == true) {
      editData();
    }
    super.initState();
  }

  //Updating Data
  updateData() {
    firestore
      ..collection('Expense List').doc(expenseIdController.text).update({
        "Date": dateController.text.trim(),
        'Purpose': purposeController.text.trim(),
        "Details": detailsController.text.trim(),
        "Amount": amountController.text.trim(),
        "Added By": addedByController.text.trim(),
        "Expense ID": expenseIdController.text.trim(),
      });
    clearFields();
  }

  //Adding Data To Firebase
  final firestore = FirebaseFirestore.instance;

  addData() async {
    final collection =
    await FirebaseFirestore.instance.collection('Expense List');
    collection.doc(expenseIdController.text).set({
      "Date": dateController.text.trim(),
      'Purpose': purposeController.text.trim(),
      "Details": detailsController.text.trim(),
      "Amount": amountController.text.trim(),
      "Added By": addedByController.text.trim(),
      "Expense ID": expenseIdController.text.trim(),
      "Farm Name": Dashboard.farmName

    });
    clearFields();
  }

  //Clearing Fields
  clearFields() {
    dateController.clear();
    purposeController.clear();
    detailsController.clear();
    amountController.clear();
    addedByController.clear();
    expenseIdController.clear();
    setState(() {});
  }

  //Avoiding Duplicate Data;
  Future<bool> doesEmailExists(String dbEmail) async {
    final QuerySnapshot results = await FirebaseFirestore.instance
        .collection('Expense List')
        .where('Expense ID', isEqualTo: expenseIdController.text.toLowerCase())
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
    AddExpense.editExpense = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Expense'),
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
                if (AddExpense.editExpense == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  // clearFields();
                  AddExpense.editExpense = false;
                }
                //Checking If Data Already Exists
                if (await doesEmailExists(
                    expenseIdController.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg: 'ID Already Exists! Please Use Another');
                } else {
                  //Adding Data
                  addData();
                  Fluttertoast.showToast(msg: 'Expense Added Successfully!');
                  // clearFields();
                  // setState(() {});
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
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 10, right: 10),
              child: Column(
                children: [
                  //Expense ID
                  MyTextField(
                    numberKeyboard: true,
                    onTap: () {
                      if (AddExpense.editExpense == true) {
                        Fluttertoast.showToast(
                            msg: 'Expense ID Cannot Be Edited!');
                      }
                    },
                    noKeyboard: AddExpense.editExpense == true ? true : false,
                    hintIcon: Icon(
                      Icons.filter_list,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Expense ID Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Expense ID',
                    controller: expenseIdController,
                  ),
                  //Added By
                  MyTypeAhead(
                      controller: addedByController,
                      firestore: firestore,
                      validatorText: 'Field Cannot Be Empty!',
                      prefixIcon: Icon(Icons.supervised_user_circle_rounded,
                        color: greenColor,),
                      hintText: 'Added By',
                      onSuggestionSelected: (val) =>
                      addedByController.text = val!,
                      onSuggestionCallback: (val) async {
                        List<String?> addedByList = [];
                        await firestore.collection('Staff List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName)
                            .get()
                            .then((QuerySnapshot querysnapshot) {
                          querysnapshot.docs.forEach((doc) {
                            if (doc['User Type'] != 'Staff') {
                              addedByList.add(
                                  '${doc['Name']}\n (${doc['User Type']})');
                            }
                          });
                        });
                        return addedByList;
                      }),
                  //Expense Purpose
                  MyTextField(
                    hintIcon: Icon(
                      Icons.note_alt_outlined,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Expense Purpose',
                    controller: purposeController,
                  ),
                  //Details
                  MyTextField(
                    hintIcon: Icon(
                      Icons.note_alt_outlined,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Put Some Details!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Details',
                    controller: detailsController,
                  ),
                  //Amount
                  MyTextField(
                    numberKeyboard: true,
                    hintIcon: Icon(
                      Icons.attach_money,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Amount',
                    controller: amountController,
                  ),
                  //Date
                  dateSelectionTextField(
                    calendarDate: dateController,
                      hintText: 'Date',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field Cannot Be Empty!';
                        } else {
                          return null;
                        }
                      },
                  )

                ],
              )),
        ),
      ),
    );
  }
}
