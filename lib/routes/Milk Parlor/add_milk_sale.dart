import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddMilkSale extends StatefulWidget {
  String? invoice;
  String? supplierName;
  String? accountNo;
  String? date;
  String? milkLTR;
  String? phoneNumber;
  String? milkPrice;
  String? total;
  String? email;
  String? soldBy;
  String? paid;
  String? due;
  String? salePrice;

  AddMilkSale(
      {this.invoice,
      this.supplierName,
      this.accountNo,
      this.date,
      this.milkLTR,
      this.phoneNumber,
      this.milkPrice,
      this.total,
      this.email,
      this.soldBy,
      this.paid,
      this.salePrice,
      this.due});

  static String id = 'AddMilkSale';
  static bool editMilkSale = false;

  @override
  State<AddMilkSale> createState() => _AddMilkSaleState();
}

class _AddMilkSaleState extends State<AddMilkSale> {
  //Controllers Storing Data of Text Fields.
  TextEditingController invoiceController = TextEditingController();
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController accountNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController milkLTRController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController soldByController = TextEditingController();
  final TextEditingController paidController = TextEditingController();
  final TextEditingController dueController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Add List Screen
  editData() {
    invoiceController.text = widget.invoice!;
    supplierNameController.text = widget.supplierName!;
    milkLTRController.text = widget.milkLTR!;
    accountNoController.text = widget.accountNo!;
    dateController.text = widget.date!;
    phoneNumberController.text = widget.phoneNumber!;
    priceController.text = widget.milkPrice!;
    totalController.text = widget.total!;
    emailController.text = widget.email!;
    soldByController.text = widget.soldBy!;
    paidController.text = widget.paid!;
    dueController.text = widget.due!;
    salePriceController.text = widget.salePrice!;
  }

  @override
  void initState() {
    if (AddMilkSale.editMilkSale == true) {
      editData();
    }
    super.initState();
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Milk Sale')
        .where('Invoice', isEqualTo: invoiceController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection = FirebaseFirestore.instance.collection('Milk Sale');

  addData() async {
    collection.doc(invoiceController.text).set({
      "Invoice": invoiceController.text.trim().toLowerCase(),
      "Supplier Name": supplierNameController.text.trim(),
      'Milk LTR': milkLTRController.text.trim(),
      "Account No": accountNoController.text.trim(),
      "Date": dateController.text.trim(),
      "Price": priceController.text.trim(),
      "Total": totalController.text.trim(),
      "Phone Number": phoneNumberController.text.trim(),
      "Email": emailController.text.trim(),
      "Sold By": soldByController.text.trim(),
      "Paid": paidController.text.trim(),
      "Due": dueController.text.trim(),
      "Sale Price": salePriceController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
  }

  // Clearing All TextFields.
  clearFields() {
    invoiceController.clear();
    supplierNameController.clear();
    milkLTRController.clear();
    accountNoController.clear();
    dateController.clear();
    totalController.clear();
    phoneNumberController.clear();
    priceController.clear();
    emailController.clear();
    soldByController.clear();
    paidController.clear();
    dueController.clear();
    salePriceController.clear();
  }

  //Updating Data
  updateData() {
    collection.doc(invoiceController.text).update({
      "Invoice": invoiceController.text.trim().toLowerCase(),
      "Supplier Name": supplierNameController.text.trim(),
      'Milk LTR': milkLTRController.text.trim(),
      "Account No": accountNoController.text.trim(),
      "Date": dateController.text.trim(),
      "Price": priceController.text.trim(),
      "Total": totalController.text.trim(),
      "Phone Number": phoneNumberController.text.trim(),
      "Email": emailController.text.trim(),
      "Sold By": soldByController.text.trim(),
      "Paid": paidController.text.trim(),
      "Due": dueController.text.trim(),
      "Sale Price": salePriceController.text.trim(),
    });
  }

  GlobalKey<FormState> key = GlobalKey();

  final firestore = FirebaseFirestore.instance;

  //Start of The Add Cow Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Milk Sale'),
        //Button To Add Data To Firebase
        actions: [
          GestureDetector(
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tap To Save Information"),
              ));
            },
            onTap: () async {
              //Checking Field Validation.
              if (key.currentState!.validate()) {
                //If Edit Data is Pressed Update the data.
                if (AddMilkSale.editMilkSale == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  clearFields();
                  AddMilkSale.editMilkSale = false;
                }

                //Checking duplicate Data.
                else if (await doesEmailAlreadyExists(
                    invoiceController.text.toLowerCase())) {
                  Fluttertoast.showToast(msg: "Invoice Number Already Exists!");
                } else {
                  //Adding Data To Firebase.
                  addData();
                  Fluttertoast.showToast(msg: "New Data Added Successfully!");
                  clearFields();
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 590.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Data TextFields
                  //Invoice
                  MyTextField(
                    numberKeyboard: true,
                    onTap: () => AddMilkSale.editMilkSale == true
                        ? Fluttertoast.showToast(
                            msg: 'Invoice Number cannot be Edited!')
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Invoice No cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Invoice No',
                    hintIcon:
                        const Icon(FontAwesomeIcons.list, color: greenColor),
                    controller: invoiceController,
                    noKeyboard: AddMilkSale.editMilkSale == true ? true : false,
                  ),
                  //Account No
                  MyTypeAhead(
                    hintText: 'Account No',
                    controller: accountNoController,
                    firestore: firestore,
                    validatorText: 'Please Choose Account Number!',
                    prefixIcon:
                        Icon(FontAwesomeIcons.userCheck, color: greenColor),
                    suffixOnTap: () {
                      accountNoController.clear();
                      priceController.clear();
                      milkLTRController.clear();
                      totalController.clear();
                      paidController.clear();
                      dueController.clear();
                      salePriceController.clear();
                    },
                    onSuggestionSelected: (value) async {
                      accountNoController.text = value!;
                      await firestore
                          .collection('Milk Collection')
                          .doc(value)
                          .get()
                          .then((snapshot) {
                        milkLTRController.text = snapshot['Milk LTR'];
                        priceController.text = snapshot['Price'];
                      });
                      if (priceController.text.isNotEmpty) {
                        double total = double.parse(salePriceController.text) *
                            double.parse(milkLTRController.text);

                        totalController.text = total.toString();
                      }
                    },
                    onSuggestionCallback: (value) async {
                      List<String?> accountNoList = [];
                      await firestore
                          .collection('Milk Collection')
                          .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          if (doc['Account No'].toLowerCase().contains(value)) {
                            accountNoList.add('${doc['Account No']}');
                          }
                        });
                      });
                      return accountNoList;
                    },
                  ),
                  //Sold By
                  MyTypeAhead(
                    hintText: 'Sold By',
                    controller: soldByController,
                    firestore: firestore,
                    validatorText: 'Field Cannot Be Empty!',
                    prefixIcon:
                        Icon(FontAwesomeIcons.userCheck, color: greenColor),
                    suffixOnTap: () => soldByController.clear(),
                    onSuggestionSelected: (value) =>
                        soldByController.text = value!,
                    onSuggestionCallback: (value) async {
                      List<String?> soldByList = [];

                  
                       await firestore
                           .collection('Staff List')
                           .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                           .then((QuerySnapshot querySnapshot) {
                         querySnapshot.docs.forEach((doc) {
                           if (doc['Name'].toLowerCase().contains(value)) {
                             soldByList
                                 .add('${doc['Name']}\n(${doc['User Type']})');
                           }
                         });
                       });
                      return soldByList;
                    },
                  ),
                  //Supplier Name
                  MyTypeAhead(
                    hintText: 'Supplier Name',
                    controller: supplierNameController,
                    firestore: firestore,
                    validatorText: 'Please Choose Supplier Name!',
                    prefixIcon:
                        Icon(FontAwesomeIcons.userCheck, color: greenColor),
                    suffixOnTap: () {
                      supplierNameController.clear();
                      emailController.clear();
                      phoneNumberController.clear();
                    },
                    onSuggestionSelected: (value) async {
                      supplierNameController.text = value!;
                      await firestore
                          .collection('Suppliers List')
                          .doc(value)
                          .get()
                          .then((snapshot) {
                        phoneNumberController.text = snapshot['Phone Number'];
                        emailController.text = snapshot['Email'];
                      });
                    },
                    onSuggestionCallback: (value) async {
                      List<String?> supplierNameList = [];
                      await firestore
                          .collection('Suppliers List')
                          .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          if (doc['Supplier Name']
                              .toLowerCase()
                              .contains(value)) {
                            supplierNameList.add('${doc['Supplier Name']}');
                          }
                        });
                      });
                      return supplierNameList;
                    },
                  ),
                  //Phone Number
                  MyTextField(
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Please Select Supplier Name'),
                    noKeyboard: true,
                    hintIcon: Icon(
                      Icons.phone,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null ||
                          phoneNumberController.text.length < 11) {
                        return 'Phone Number Must Be 11 Characters long!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Phone Number',
                    controller: phoneNumberController,
                  ),
                  //Email
                  MyTextField(
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Please Select Supplier Name'),
                    noKeyboard: true,
                    hintIcon: Icon(
                      Icons.email_outlined,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Email Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  //Milk LTR
                  MyTextField(
                    onChanged: (va) {},
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Please Select Account Number'),
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Milk LTR Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Milk LTR',
                    hintIcon: Icon(FontAwesomeIcons.cow, color: greenColor),
                    controller: milkLTRController,
                  ),
                  //Milk Collection Price
                  MyTextField(
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Please Select Account Number'),
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Milk Collection Price',
                    hintIcon:
                        Icon(Icons.price_check_outlined, color: greenColor),
                    controller: priceController,
                  ),
                  //Milk Sale Price
                  MyTextField(
                    numberKeyboard: true,
                    onChanged: (val) {
                      if (milkLTRController.text.isNotEmpty) {
                        double total = double.parse(salePriceController.text) *
                            double.parse(milkLTRController.text);
                        totalController.text = total.toString();

                        if (paidController.text.isNotEmpty) {
                          double due = double.parse(totalController.text) -
                              double.parse(paidController.text);
                          dueController.text = due.toString();
                        }
                      } else {
                        totalController.clear();
                        paidController.clear();
                        dueController.clear();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Milk Sale Price',
                    hintIcon:
                        Icon(Icons.price_check_outlined, color: greenColor),
                    controller: salePriceController,
                  ),
                  //Total
                  MyTextField(
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Please Put Milk Sale Price'),
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Total Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Total',
                    hintIcon:
                        Icon(Icons.price_check_outlined, color: greenColor),
                    controller: totalController,
                  ),
                  //Paid
                  MyTextField(
                    onChanged: (val) {
                      if (paidController.text.isNotEmpty) {
                        double due = double.parse(totalController.text) -
                            double.parse(paidController.text);
                        dueController.text = due.toString();
                      } else {
                        dueController.clear();
                      }
                    },
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Paid Field cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Paid',
                    hintIcon: const Icon(Icons.payment, color: greenColor),
                    controller: paidController,
                  ),
                  //Due
                  MyTextField(
                    onTap: () =>
                        Fluttertoast.showToast(msg: 'Please Add Paid Amount'),
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Due Field cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Due',
                    hintIcon:
                        const Icon(Icons.payments_outlined, color: greenColor),
                    controller: dueController,
                  ),

                  //Date
                  dateSelectionTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Date!';
                        } else {
                          return null;
                        }
                      },
                      calendarDate: dateController,
                      hintText: 'Date')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
