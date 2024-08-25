import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddMilkCollection extends StatefulWidget {
  String? animalID;
  String? stallNo;
  String? accountNo;
  String? date;
  String? milkLTR;
  String? fat;
  String? price;
  String? total;
  String? collectedBy;
  String? addedBy;

  AddMilkCollection({
    this.animalID,
    this.stallNo,
    this.accountNo,
    this.date,
    this.milkLTR,
    this.fat,
    this.price,
    this.total,
    this.collectedBy,
    this.addedBy,
  });


  static String id = 'AddMilkCollection';
  static bool editMilkCollection = false;

  @override
  State<AddMilkCollection> createState() => _AddMilkCollectionState();
}

class _AddMilkCollectionState extends State<AddMilkCollection> {

  //Controllers Storing Data of Text Fields.
  TextEditingController animalIdController = TextEditingController();
  final TextEditingController stallNoController = TextEditingController();
  final TextEditingController accountNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController milkLTRController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController collectedByController = TextEditingController();
  final TextEditingController addedByController = TextEditingController();


  //Filling TextFields Automatically If Edit Button Is Pressed On Add List Screen
  editData() {
    animalIdController.text = widget.animalID!;
    stallNoController.text = widget.stallNo!;
    milkLTRController.text = widget.milkLTR!;
    accountNoController.text = widget.accountNo!;
    dateController.text = widget.date!;
    fatController.text = widget.fat!;
    priceController.text = widget.price!;
    totalController.text = widget.total!;
    collectedByController.text = widget.collectedBy!;
    addedByController.text = widget.addedBy!;
  }

  @override
  void initState() {
    if (AddMilkCollection.editMilkCollection == true) {
      editData();
      super.initState();
    }
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Milk Collection')
        .where('Account No', isEqualTo: accountNoController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection = FirebaseFirestore.instance.collection('Milk Collection');
  addData() async {
    final auth = FirebaseAuth.instance.currentUser?.uid;

    collection.doc(accountNoController.text).set({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Milk LTR': milkLTRController.text.trim(),
      "Account No": accountNoController.text.trim(),
      "Date": dateController.text.trim(),
      "Price": priceController.text.trim(),
      "Total": totalController.text.trim(),
      "Fat": fatController.text.trim(),
      "Collected By": collectedByController.text.trim(),
      "Added By": addedByController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
    clearFields();
  }
  // Clearing All TextFields.
  clearFields() {
    animalIdController.clear();
    stallNoController.clear();
    milkLTRController.clear();
    accountNoController.clear();
    dateController.clear();
    totalController.clear();
    fatController.clear();
    priceController.clear();
    collectedByController.clear();
    addedByController.clear();
    setState(() {});
  }

  //Updating Data
  updateData() {
    collection.doc(accountNoController.text).update({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Milk LTR': milkLTRController.text.trim(),
      "Account No": accountNoController.text.trim(),
      "Date": dateController.text.trim(),
      "Price": priceController.text.trim(),
      "Total": totalController.text.trim(),
      "Fat": fatController.text.trim(),
      "Collected By": collectedByController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
    clearFields();
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
        title: const Text('Add Milk Collection'),
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
                if (AddMilkCollection.editMilkCollection == true) {
                  updateData();
                  Fluttertoast.showToast(
                      msg: "Data Updated Successfully!");
                  // clearFields();
                  AddMilkCollection.editMilkCollection = false;
                }
                //Checking duplicate Data.
                else if (await doesEmailAlreadyExists(
                    accountNoController.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg: "Account Number Already Exists!");
                } else {
                  //Adding Data To Firebase.
                  addData();
                  Fluttertoast.showToast(
                      msg: "New Data Added Successfully!");
                  // clearFields();
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
                  //Stall No
                  MyTypeAhead(
                    hintText: 'Stall No',
                    controller: stallNoController,
                    firestore: firestore,
                    validatorText: 'Please Choose Stall No!',
                    prefixIcon: Icon(
                        Icons.house_outlined,
                        color: greenColor),
                    suffixOnTap: () => stallNoController.clear(),
                    onSuggestionSelected: (value) => stallNoController.text = value!,
                    onSuggestionCallback: (value) async {
                      List<String?> stallNoList = [];
                      await firestore
                          .collection('Stalls List')
                          .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          if (doc['Stall'].toLowerCase().contains(value)) {
                            stallNoList.add('${doc['Stall']}');
                          }
                        });
                      });
                      return stallNoList;
                    },
                  ),
                  //Animal ID
                  MyTypeAhead(
                    hintText: 'Animal ID',
                    controller: animalIdController,
                    firestore: firestore,
                    validatorText: 'Please Choose Animal ID!',
                    prefixIcon: Icon(
                        FontAwesomeIcons.paw,
                        color: greenColor),
                      suffixOnTap: () => animalIdController.clear(),
                    onSuggestionSelected: (value) => animalIdController.text = value!,
                    onSuggestionCallback: (value) async {
                      List<String?> animalIdList = [];
                      await firestore
                          .collection('Cows List')
                          .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          if (doc['Animal Id'].toLowerCase().contains(value)) {
                            animalIdList.add('${doc['Animal Id']}');
                          }
                        });
                      });
                      return animalIdList;
                    },
                  ),
                  //Collected By
                  MyTypeAhead(
                    hintText: 'Collected By',
                    controller: collectedByController,
                    firestore: firestore,
                    validatorText: 'Field Cannot Be Empty!',
                    prefixIcon: Icon(
                        FontAwesomeIcons.userCheck,
                        color: greenColor),
                    suffixOnTap: () => collectedByController.clear(),
                    onSuggestionSelected: (value) => collectedByController.text = value!,
                    onSuggestionCallback: (value) async {
                      List<String?> collectedByList = [];
                      await firestore
                          .collection('Staff List')
                          .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          if (doc['Name'].toLowerCase().contains(value) && doc['User Type'] == 'Staff') {
                            collectedByList.add('${doc['Name']}\n(${doc['User Type']})');
                          }
                        });
                      });
                      return collectedByList;
                    },
                  ),
                  //Added By
                  MyTypeAhead(
                    hintText: 'Added By',
                    controller: addedByController,
                    firestore: firestore,
                    validatorText: 'Field Cannot Be Empty!',
                    prefixIcon: Icon(
                        FontAwesomeIcons.userAstronaut,
                        color: greenColor),
                    suffixOnTap: () => addedByController.clear(),
                    onSuggestionSelected: (value) => addedByController.text = value!,
                    onSuggestionCallback: (value) async {
                      List<String?> addedByList = [];
                      await firestore
                          .collection('Staff List')
                          .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          if (doc['Name'].toLowerCase().contains(value) && doc['User Type'] != 'Staff') {
                            addedByList.add('${doc['Name']}\n(${doc['User Type']})');
                          }
                        });
                      });
                      return addedByList;
                    },
                  ),
                  //Account No
                  MyTextField(
                    numberKeyboard: true,
                    onTap: () =>
                    AddMilkCollection.editMilkCollection == true
                        ? Fluttertoast.showToast(
                        msg: 'Account Number cannot be Edited!')
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account No cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Account No',
                    hintIcon: const Icon(FontAwesomeIcons.paw,
                        color: greenColor),
                    controller: accountNoController,
                    noKeyboard: AddMilkCollection.editMilkCollection == true
                        ? true
                        : false,
                  ),
                  //Fat
                  MyTextField(
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fat Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Fat (KG)',
                    hintIcon: Icon(FontAwesomeIcons.cow,
                        color: greenColor),
                    controller: fatController,
                  ),
                  //Milk LTR
                  MyTextField(
                    onChanged: (val){
                      if(milkLTRController.text.isNotEmpty){
                        if(priceController.text.isNotEmpty){
                          double total = double.parse(priceController.text) * double.parse(milkLTRController.text);
                          totalController.text = total.toString();
                        }else{
                          totalController.text = priceController.text;
                        }
                      }else{
                        priceController.clear();
                        totalController.clear();
                      }
                    },
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Milk LTR Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Milk LTR',
                    hintIcon: Icon(FontAwesomeIcons.cow,
                        color: greenColor),
                    controller: milkLTRController,
                  ),
                  //Price
                  MyTextField(
                    onTap: () {
                      if(milkLTRController.text.isEmpty){
                        Fluttertoast.showToast(msg: 'Please Add Milk LTR First');
                      }
                    },
                    onChanged: (val){
                      if(priceController.text.isNotEmpty){
                        double total = double.parse(priceController.text) * double.parse(milkLTRController.text);
                        totalController.text = total.toString();
                      }else{
                        totalController.text = priceController.text;
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
                    hintText: 'Price',
                    hintIcon: Icon(Icons.price_check_outlined,
                        color: greenColor),
                    controller: priceController,
                  ), //
                  //Total
                  MyTextField(
                    onTap: (){
                      Fluttertoast.showToast(msg: 'Please Add Milk LTR And Price!');
                    },
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Total Field Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Total',
                    hintIcon: Icon(Icons.price_check_outlined,
                        color: greenColor),
                    controller: totalController,
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
