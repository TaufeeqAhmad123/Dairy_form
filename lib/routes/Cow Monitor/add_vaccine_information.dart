import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddVaccineInformation extends StatefulWidget {
  String? animalID;
  String? stallNo;
  String? vaccineName;
  String? date;
  String? note;
  String? reportedBy;
  String? givenTime;
  String? dose;

  AddVaccineInformation({
    this.animalID,
    this.stallNo,
    this.vaccineName,
    this.date,
    this.note,
    this.reportedBy,
    this.givenTime,
    this.dose,
  });

  static String id = 'AddVaccineInformation';
  static bool editVaccine = false;

  @override
  State<AddVaccineInformation> createState() => _AddVaccineInformationState();
}

class _AddVaccineInformationState extends State<AddVaccineInformation> {
  //Controllers Storing Data of Text Fields.
  TextEditingController animalIdController = TextEditingController();
  final TextEditingController stallNoController = TextEditingController();
  final TextEditingController vaccineNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController reportedByController = TextEditingController();
  final TextEditingController givenTimeController = TextEditingController();
  final TextEditingController doseController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Cow List Screen
  editData() {
    animalIdController.text = widget.animalID!;
    stallNoController.text = widget.stallNo!;
    noteController.text = widget.note!;
    vaccineNameController.text = widget.vaccineName!;
    dateController.text = widget.date!;
    reportedByController.text = widget.reportedBy!;
    givenTimeController.text = widget.givenTime!;
    doseController.text = widget.dose!;
  }

  @override
  void initState() {
    if (AddVaccineInformation.editVaccine == true) {
      editData();
      super.initState();
    }
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Vaccine Information')
        .where('Animal Id', isEqualTo: animalIdController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection =
  FirebaseFirestore.instance.collection('Vaccine Information');

  addData() async {
    collection.doc(animalIdController.text).set({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Vaccine Name": vaccineNameController.text.trim(),
      "Date": dateController.text.trim(),
      "Reported By": reportedByController.text.trim(),
      "Given Time": givenTimeController.text.trim(),
      "Dose": doseController.text.trim(),
      "Farm Name": Dashboard.farmName

    });
  }

  final firestore = FirebaseFirestore.instance;

  // Clearing All TextFields.
  clearFields() {
    animalIdController.clear();
    stallNoController.clear();
    noteController.clear();
    vaccineNameController.clear();
    dateController.clear();
    reportedByController.clear();
    givenTimeController.clear();
    doseController.clear();
  }

  //Updating Data
  updateData() {
    collection.doc(animalIdController.text).update({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Vaccine Name": vaccineNameController.text.trim(),
      "Date": dateController.text.trim(),
      "Reported By": reportedByController.text.trim(),
      "Given Time": givenTimeController.text.trim(),
      "Dose": doseController.text.trim(),
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
        title: const Text('Add Vaccine Information'),
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
                if (AddVaccineInformation.editVaccine == true) {
                  updateData();
                  Fluttertoast.showToast(msg: "Data Updated Successfully!");
                  clearFields();
                  AddVaccineInformation.editVaccine = false;
                }

                //Checking duplicate Data.
                else if (await doesEmailAlreadyExists(
                    animalIdController.text.toLowerCase())) {
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Warning!'),
                      content: Text('Vaccine For This Animal Already Exists, Do You Want To Add Again?'),
                      actions: [
                        CustomButton(buttonName: 'Yes',onPressed: (){
                          index++;
                          animalIdController.text = '${animalIdController.text} ($index)';
                          addData();
                          Fluttertoast.showToast(msg: "New Data Added Successfully!");
                          clearFields();
                          Navigator.pop(context);
                        },),
                        CustomButton(buttonName: 'Cancel',onPressed: () => Navigator.pop(context),)
                      ],
                    );
                  });
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
                      hideKeyboard: AddVaccineInformation.editVaccine == true
                          ? true
                          : false,
                      onTap: () {
                        AddVaccineInformation.editVaccine
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
                            if(AddVaccineInformation.editVaccine != true) {
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
                  //Vaccine Name
                  MyDropdownButton(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Vaccine Name';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Vaccine Name',
                      icon: Icon(FontAwesomeIcons.userDoctor,color: greenColor,),
                      onChanged: (val){
                        vaccineNameController.text = val;
                      },
                      dropDownList: [
                        DropdownMenuItem(child: Text('Anthrax - ( 120 Days )'),value: 'Anthrax - ( 120 Days )',),
                        DropdownMenuItem(child: Text('BDV - ( 60 Days )'),value: 'BDV - ( 60 Days )',),
                        DropdownMenuItem(child: Text('BRSV - ( 365 Days )'),value: 'BRSV - ( 365 Days )',),
                        DropdownMenuItem(child: Text('BVD - ( 90 Days )'),value: 'BVD - ( 90 Days )',),
                        DropdownMenuItem(child: Text('PI3 - ( 120 Days )'),value: 'PI3 - ( 120 Days )',),
                        DropdownMenuItem(child: Text('Vitamin A - ( 60 Days )'),value: 'Vitamin A - ( 60 Days )',)
                      ]),
                  //Dose
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Dose:',
                    hintIcon: const Icon(FontAwesomeIcons.listCheck,
                        color: greenColor, size: 18.0),
                    controller: doseController,
                  ),
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
                  //Given Time
                  MyTextField(
                    noKeyboard: true,
                    numberKeyboard: true,
                    onTap: ()async{
                      TimeOfDay? picker = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      setState(() {
                        givenTimeController.text = picker!.format(context).toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select Time';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Given Time:',
                    hintIcon: const Icon(FontAwesomeIcons.clock,
                        color: greenColor, size: 18.0),
                    controller: givenTimeController,
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
