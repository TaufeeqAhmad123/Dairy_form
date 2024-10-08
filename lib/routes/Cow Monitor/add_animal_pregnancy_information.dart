import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddAnimalPregnancyInformation extends StatefulWidget {


  String? animalID;
  String? stallNo;
  String? pregnancyStartDate;
  String? note;
  String? pregnancyType;
  String? semenType;
  String? deliveryTime;

  AddAnimalPregnancyInformation({
    this.animalID,
    this.stallNo,
    this.pregnancyType,
    this.pregnancyStartDate,
    this.note,
    this.semenType,
    this.deliveryTime,
  });

  static String id = 'AddAnimalPregnancyInformation';
  static bool editPregnancy = false;

  @override
  State<AddAnimalPregnancyInformation> createState() =>
      _AddAnimalPregnancyInformationState();
}

class _AddAnimalPregnancyInformationState
    extends State<AddAnimalPregnancyInformation> {
  //Controllers Storing Data of Text Fields.
  TextEditingController animalIdController = TextEditingController();
  final TextEditingController stallNoController = TextEditingController();
  final TextEditingController pregnancyTypeController = TextEditingController();
  final TextEditingController pregnancyDateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController semenTypeController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Cow List Screen
  editData() {
    animalIdController.text = widget.animalID!;
    stallNoController.text = widget.stallNo!;
    noteController.text = widget.note!;
    pregnancyTypeController.text = widget.pregnancyType!;
    pregnancyDateController.text = widget.pregnancyStartDate!;
    semenTypeController.text = widget.semenType!;
    deliveryTimeController.text = widget.deliveryTime!;
  }

  @override
  void initState() {
    if (AddAnimalPregnancyInformation.editPregnancy == true) {
      editData();
      super.initState();
    }
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Animal Pregnancy')
        .where('Animal Id', isEqualTo: animalIdController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection =
  FirebaseFirestore.instance.collection('Animal Pregnancy');

  addData() async {
    collection.doc(animalIdController.text).set({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Pregnancy Type": pregnancyTypeController.text.trim(),
      "Pregnancy Date": pregnancyDateController.text.trim(),
      "Semen Type": semenTypeController.text.trim(),
      "Delivery Time": deliveryTimeController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
  }

  final firestore = FirebaseFirestore.instance;

  // Clearing All TextFields.
  clearFields() {
    animalIdController.clear();
    stallNoController.clear();
    noteController.clear();
    pregnancyTypeController.clear();
    pregnancyDateController.clear();
    semenTypeController.clear();
    deliveryTimeController.clear();
  }

  //Updating Data
  updateData() {
    collection.doc(animalIdController.text).update({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Pregnancy Type": pregnancyTypeController.text.trim(),
      "Pregnancy Date": pregnancyDateController.text.trim(),
      "Semen Type": semenTypeController.text.trim(),
      "Delivery Time": deliveryTimeController.text.trim(),
    });
  }

  GlobalKey<FormState> key = GlobalKey();

  int index = 0;

  //Start of The Add Staff Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Animal Pregnancy'),
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
                if (AddAnimalPregnancyInformation.editPregnancy == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  clearFields();
                  AddAnimalPregnancyInformation.editPregnancy = false;
                }

                //Checking duplicate Data.
                else if (await doesEmailAlreadyExists(
                    animalIdController.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg: "Animal ID Already Exists Please Use Different ID!");
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
                children: [
                  //Data TextFields
                  //Animal Id
                  MyTypeAhead(
                      hideKeyboard: AddAnimalPregnancyInformation
                          .editPregnancy == true
                          ? true
                          : false,
                      onTap: () {
                        AddAnimalPregnancyInformation.editPregnancy
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
                      },
                      hintText: 'Animal ID (Cow)',
                      onSuggestionSelected: (val) {
                        animalIdController.text = val!;
                      },
                      onSuggestionCallback: (val) async {
                        List<String?> animalIdList = [];
                        await firestore
                            .collection('Cows List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            if (AddAnimalPregnancyInformation.editPregnancy !=
                                true) {
                              animalIdList.add(doc['Animal Id']);
                            }
                          });
                        });
                        return animalIdList;
                      }),
                  //Stall No
                  MyTypeAhead(
                      controller: stallNoController,
                      firestore: firestore,
                      validatorText: 'Please Select Stall No',
                      prefixIcon: Icon(
                        FontAwesomeIcons.building,
                        color: greenColor,
                      ),
                      suffixOnTap: () {
                        stallNoController.clear();
                      },
                      hintText: 'Stall No',
                      onSuggestionSelected: (val) {
                        stallNoController.text = val!;
                      },
                      onSuggestionCallback: (val) async {
                        List<String?> stallNoList = [];
                        await firestore
                            .collection('Stalls List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            stallNoList.add(doc['Stall']);
                          });
                        });
                        return stallNoList;
                      }),
                  //Pregnancy Type
                  MyDropdownButton(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Pregnancy Type';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Pregnancy Type',
                      icon: Icon(
                        FontAwesomeIcons.userDoctor, color: greenColor,),
                      onChanged: (val) {
                        pregnancyTypeController.text = val;
                      },
                      dropDownList: [
                        DropdownMenuItem(
                          child: Text('Automatic'), value: 'Automatic',),
                        DropdownMenuItem(child: Text('By Collected Semen'),
                          value: 'By Collected Semen',),
                      ]),
                  //Semen Type
                  MyDropdownButton(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose a Semen Type';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Semen Type',
                      icon: Icon(
                        FontAwesomeIcons.cow,
                        color: greenColor,
                      ),
                      onChanged: (newValue) {
                        semenTypeController.text = newValue;
                      },
                      dropDownList: [
                        DropdownMenuItem(
                          child: Text('Sindhi'),
                          value: 'Sindhi',
                        ),
                        DropdownMenuItem(
                          child: Text('Brahman'),
                          value: 'Brahman',
                        ),
                        DropdownMenuItem(
                          child: Text('Holstein'),
                          value: 'Holstein',
                        ), DropdownMenuItem(
                          child: Text('Mundi'),
                          value: 'Mundi',
                        ), DropdownMenuItem(
                          child: Text('Friesien'),
                          value: 'Friesien',
                        ),
                        DropdownMenuItem(
                          child: Text('Jersey'),
                          value: 'Jersey',
                        ), DropdownMenuItem(
                          child: Text('Sahiwal'),
                          value: 'Sahiwal',
                        ),
                      ]),
                  //Note:
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Note:',
                    hintIcon: const Icon(FontAwesomeIcons.noteSticky,
                        color: greenColor, size: 18.0),
                    controller: noteController,
                  ),
                  //Pregnancy Start Date
                  MyTextField(
                    onTap: () async {
                      final DateTime? picker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      setState(() {
                        pregnancyDateController.text = DateFormat.yMd().format(picker!).toString();
                        DateTime deliveryDate = DateTime(picker.year,picker.month,picker.day + 283);
                        deliveryTimeController.text = DateFormat.yMd().format(deliveryDate).toString() + ' (Delivery Date)';
                      });
                    },
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Pregnancy Start Date:',
                    hintIcon: const Icon(FontAwesomeIcons.calendarPlus,
                        color: greenColor, size: 18.0),
                    controller: pregnancyDateController,
                  ),
                  //Delivery Time
                  MyTextField(
                    onTap: () => Fluttertoast.showToast(msg: 'Please Select Pregnancy Start Date!'),
                    noKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Approximate Delivery Date:',
                    hintIcon: const Icon(FontAwesomeIcons.calendarMinus,
                        color: greenColor, size: 18.0),
                    controller: deliveryTimeController,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
