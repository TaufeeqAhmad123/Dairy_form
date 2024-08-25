import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddRoutineInformation extends StatefulWidget {
  String? animalID;
  String? stallNo;
  String? healthStatus;
  String? date;
  String? note;
  String? reportedBy;

  AddRoutineInformation({
    this.animalID,
    this.stallNo,
    this.healthStatus,
    this.date,
    this.note,
    this.reportedBy,
  });

  static String id = 'AddRoutineInformation';
  static bool editRoutine = false;

  @override
  State<AddRoutineInformation> createState() => _AddRoutineInformationState();
}

class _AddRoutineInformationState extends State<AddRoutineInformation> {
  //Controllers Storing Data of Text Fields.
  TextEditingController animalIdController = TextEditingController();
  final TextEditingController stallNoController = TextEditingController();
  final TextEditingController healthStatusController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController reportedByController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Cow List Screen
  editData() {
    animalIdController.text = widget.animalID!;
    stallNoController.text = widget.stallNo!;
    noteController.text = widget.note!;
    healthStatusController.text = widget.healthStatus!;
    dateController.text = widget.date!;
    reportedByController.text = widget.reportedBy!;
  }

  @override
  void initState() {
    if (AddRoutineInformation.editRoutine == true) {
      editData();
      super.initState();
    }
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Routine Information')
        .where('Animal Id', isEqualTo: animalIdController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection =
  FirebaseFirestore.instance.collection('Routine Information');

  addData() async {
    collection.doc(animalIdController.text).set({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Health Status": healthStatusController.text.trim(),
      "Date": dateController.text.trim(),
      "Reported By": reportedByController.text.trim(),
      "Farm Name": Dashboard.farmName

    });
  }

  final firestore = FirebaseFirestore.instance;

  // Clearing All TextFields.
  clearFields() {
    animalIdController.clear();
    stallNoController.clear();
    noteController.clear();
    healthStatusController.clear();
    dateController.clear();
    reportedByController.clear();
  }

  //Updating Data
  updateData() {
    collection.doc(animalIdController.text).update({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Health Status": healthStatusController.text.trim(),
      "Date": dateController.text.trim(),
      "Reported By": reportedByController.text.trim(),
    });
  }

  GlobalKey<FormState> key = GlobalKey();

  //Start of The Add Staff Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Routine Information'),
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
                if (AddRoutineInformation.editRoutine == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  clearFields();
                  AddRoutineInformation.editRoutine = false;
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
                      hideKeyboard: AddRoutineInformation.editRoutine == true
                          ? true
                          : false,
                      onTap: () {
                        AddRoutineInformation.editRoutine
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
                            if(AddRoutineInformation.editRoutine != true) {
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
                  //Reported By
                  MyTypeAhead(
                      controller: reportedByController,
                      firestore: firestore,
                      validatorText: 'Field Cannot Be Empty',
                      prefixIcon: Icon(
                        FontAwesomeIcons.building,
                        color: greenColor,
                      ),
                      suffixOnTap: () {
                        reportedByController.clear();
                      },
                      hintText: 'Reported By',
                      onSuggestionSelected: (val) {
                        reportedByController.text = val!;
                      },
                      onSuggestionCallback: (val) async {
                        List<String?> reportedByLisy = [];
                        await firestore
                            .collection('Staff List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            if (doc['User Type'] != 'Staff') {
                              reportedByLisy.add(
                                  '${doc['Name']}\n(${doc['User Type']})');
                            }
                          });
                        });
                        return reportedByLisy;
                      }),
                  //Health Status
                  MyDropdownButton(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Health Status';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Health Status',
                      icon: Icon(FontAwesomeIcons.userDoctor,color: greenColor,),
                      onChanged: (val){
                        healthStatusController.text = val;
                      },
                      dropDownList: [
                        DropdownMenuItem(child: Text('Perfect Health 100/100'),value: 'Perfect Health',),
                        DropdownMenuItem(child: Text('Good Condition 75/100'),value: 'Good Condition',),
                        DropdownMenuItem(child: Text('Normal Condition 50/100'),value: 'Normal Condition',),
                        DropdownMenuItem(child: Text('Need Medical Attention 25/100'),value: 'Need Medical Attention',),
                        DropdownMenuItem(child: Text('Emergency! 10/100'),value: 'Emergency!',)
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
                  //Report Date
                  dateSelectionTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Date!';
                        } else {
                          return null;
                        }
                      },
                      calendarDate: dateController,
                      hintText: 'Report Date')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
