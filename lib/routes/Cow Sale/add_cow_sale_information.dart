import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddCowSaleInformation extends StatefulWidget {
  String? invoice;
  String? customerName;
  String? date;
  String? phoneNumber;
  String? price;
  String? email;
  String? address;
  String? paid;
  String? due;
  String? animalId;

  AddCowSaleInformation({this.invoice,
    this.customerName,
    this.date,
    this.phoneNumber,
    this.price,
    this.email,
    this.address,
    this.paid,
    this.animalId,
    this.due});

  static String id = 'AddCowSaleInformation';
  static bool editCowSale = false;

  @override
  State<AddCowSaleInformation> createState() => _AddCowSaleInformationState();
}

class _AddCowSaleInformationState extends State<AddCowSaleInformation> {
  //Controllers Storing Data of Text Fields.
  TextEditingController invoiceController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController paidController = TextEditingController();
  final TextEditingController dueController = TextEditingController();
  final TextEditingController animalIdController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Add List Screen
  editData() {
    invoiceController.text = widget.invoice!;
    customerNameController.text = widget.customerName!;
    dateController.text = widget.date!;
    phoneNumberController.text = widget.phoneNumber!;
    priceController.text = widget.price!;
    emailController.text = widget.email!;
    addressController.text = widget.address!;
    paidController.text = widget.paid!;
    dueController.text = widget.due!;
    animalIdController.text = widget.animalId!;
  }

  @override
  void initState() {
    if (AddCowSaleInformation.editCowSale == true) {
      editData();
    }
    super.initState();
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Cow Sale')
        .where('Animal Id', isEqualTo: animalIdController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection = FirebaseFirestore.instance.collection('Cow Sale');

  addData() async {
    collection.doc(animalIdController.text).set({
      "Invoice": invoiceController.text.trim().toLowerCase(),
      "Customer Name": customerNameController.text.trim(),
      "Date": dateController.text.trim(),
      "Price": priceController.text.trim(),
      "Phone Number": phoneNumberController.text.trim(),
      "Email": emailController.text.trim(),
      "Address": addressController.text.trim(),
      "Paid": paidController.text.trim(),
      "Due": dueController.text.trim(),
      "Animal Id": animalIdController.text.trim(),
      "Farm Name": Dashboard.farmName

    });
  }

  // Clearing All TextFields.
  clearFields() {
    invoiceController.clear();
    customerNameController.clear();
    dateController.clear();
    phoneNumberController.clear();
    priceController.clear();
    emailController.clear();
    addressController.clear();
    paidController.clear();
    dueController.clear();
    animalIdController.clear();
  }

  //Updating Data
  updateData() {
    collection.doc(invoiceController.text).update({
      "Invoice": invoiceController.text.trim().toLowerCase(),
      "Customer Name": customerNameController.text.trim(),
      "Date": dateController.text.trim(),
      "Price": priceController.text.trim(),
      "Phone Number": phoneNumberController.text.trim(),
      "Email": emailController.text.trim(),
      "Address": addressController.text.trim(),
      "Paid": paidController.text.trim(),
      "Due": dueController.text.trim(),
      "Animal Id": animalIdController.text.trim(),
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
        title: const Text('Add Cow Sale'),
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
                if (AddCowSaleInformation.editCowSale == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  clearFields();
                  AddCowSaleInformation.editCowSale = false;
                }

                //Checking duplicate Data.
                else if (await doesEmailAlreadyExists(
                    animalIdController.text.toLowerCase())) {
                  Fluttertoast.showToast(msg: "Animal Id Already Exists!");
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
                  //Animal ID
                  MyTypeAhead(
                      hideKeyboard: AddCowSaleInformation
                          .editCowSale == true
                          ? true
                          : false,
                      onTap: () {
                        AddCowSaleInformation.editCowSale
                            ? Fluttertoast.showToast(
                            msg: 'Animal ID Cannot Be Edited')
                            : null;
                      },
                      controller: animalIdController,
                      firestore: firestore,
                      validatorText: 'Please Select Animal ID',
                      prefixIcon: Icon(
                        FontAwesomeIcons.paw,
                        color: greenColor,
                      ),
                      suffixOnTap: () {
                        animalIdController.clear();
                        invoiceController.clear();
                      },
                      hintText: 'Animal ID (Cow)',
                      onSuggestionSelected: (val) {
                        animalIdController.text = val!;
                        invoiceController.text = val!;
                      },
                      onSuggestionCallback: (val) async {
                        List<String?> animalIdList = [];
                        await firestore
                            .collection('Cows List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            if (AddCowSaleInformation.editCowSale !=
                                true) {
                              animalIdList.add(doc['Animal Id']);
                            }
                          });
                        });
                        return animalIdList;
                      }),
                  //Invoice
                  MyTextField(
                    numberKeyboard: true,
                    onTap: () => Fluttertoast.showToast(msg: 'Please Select Animal Id'),
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
                    noKeyboard: true,
                  ),
                  //Customer Name
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Customer Name be empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Customer Name',
                    hintIcon:
                    const Icon(FontAwesomeIcons.user, color: greenColor),
                    controller: customerNameController,
                  ),
                  //Phone Number
                  MyTextField(
                    numberKeyboard: true,
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
                  //Address By
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Address',
                    hintIcon: const Icon(FontAwesomeIcons.addressBook,
                        color: greenColor),
                    controller: addressController,
                  ),
                  //Price
                  MyTextField(
                    onChanged: (val) {
                      if (priceController.text.isNotEmpty) {
                        if (paidController.text.isNotEmpty) {
                          double due = double.parse(priceController.text) -
                              double.parse(paidController.text);
                          dueController.text = due.toString();
                        }
                      } else {
                        dueController.clear();
                        paidController.clear();
                      }
                    },
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Sale Price',
                    hintIcon:
                    Icon(Icons.price_check_outlined, color: greenColor),
                    controller: priceController,
                  ),
                  //Paid
                  MyTextField(
                    onChanged: (val) {
                      if (paidController.text.isNotEmpty) {
                        double due = double.parse(priceController.text) -
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
                        Fluttertoast.showToast(msg: 'Please Add Price Amount'),
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
