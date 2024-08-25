import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddCowFeedInformation extends StatefulWidget {
  String? animalID;
  String? stallNo;
  String? grass;
  String? date;
  String? note;
  String? feedingTime;
  String? salt;
  String? water;

  AddCowFeedInformation({
    this.animalID,
    this.stallNo,
    this.grass,
    this.date,
    this.note,
    this.feedingTime,
    this.salt,
    this.water,
  });


  static String id = 'AddCowFeedInformation';
  static bool editCowFeed = false;

  @override
  State<AddCowFeedInformation> createState() => _AddCowFeedInformationState();
}

class _AddCowFeedInformationState extends State<AddCowFeedInformation> {

  //Controllers Storing Data of Text Fields.
  TextEditingController animalIdController = TextEditingController();
  final TextEditingController stallNoController = TextEditingController();
  final TextEditingController grassController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController feedingTimeController = TextEditingController();
  final TextEditingController saltController = TextEditingController();
  final TextEditingController waterController = TextEditingController();


  //Filling TextFields Automatically If Edit Button Is Pressed On Cow List Screen
  editData() {
    animalIdController.text = widget.animalID!;
    stallNoController.text = widget.stallNo!;
    noteController.text = widget.note!;
    grassController.text = widget.grass!;
    dateController.text = widget.date!;
    feedingTimeController.text = widget.feedingTime!;
    saltController.text = widget.salt!;
    waterController.text = widget.water!;
  }

  @override
  void initState() {
    if (AddCowFeedInformation.editCowFeed == true) {
      editData();
      super.initState();
    }
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Cow Feed Information')
        .where('Animal Id', isEqualTo: animalIdController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection = FirebaseFirestore.instance.collection(
      'Cow Feed Information');

  addData() async {
    collection.doc(animalIdController.text).set({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Grass": grassController.text.trim(),
      "Date": dateController.text.trim(),
      "Feeding Time": feedingTimeController.text.trim(),
      "Salt": saltController.text.trim(),
      "Water": waterController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
  }

  final firestore = FirebaseFirestore.instance;


  // Clearing All TextFields.
  clearFields() {
    animalIdController.clear();
    stallNoController.clear();
    noteController.clear();
    grassController.clear();
    dateController.clear();
    feedingTimeController.clear();
    saltController.clear();
    waterController.clear();
  }

  //Updating Data
  updateData() {
    collection.doc(animalIdController.text).update({
      "Animal Id": animalIdController.text.trim().toLowerCase(),
      "Stall No": stallNoController.text.trim(),
      'Note:': noteController.text.trim(),
      "Grass": grassController.text.trim(),
      "Date": dateController.text.trim(),
      "Feeding Time": feedingTimeController.text.trim(),
      "Salt": feedingTimeController.text.trim(),
      "Water": feedingTimeController.text.trim(),
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
        title: const Text('Add Cow Feed Information'),
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
                if (AddCowFeedInformation.editCowFeed == true) {
                  updateData();
                  Fluttertoast.showToast(
                      msg: "Data Updated Successfully!");
                  clearFields();
                  AddCowFeedInformation.editCowFeed = false;
                }

                //Checking duplicate Data.
                else if (await doesEmailAlreadyExists(
                    animalIdController.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg: "Animal ID Already Exists Please Use Different ID!");
                } else {
                  //Adding Data To Firebase.
                  addData();
                  Fluttertoast.showToast(
                      msg: "New Data Added Successfully!");
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
                      hideKeyboard: AddCowFeedInformation.editCowFeed == true
                          ? true
                          : false,
                      onTap: () {
                        AddCowFeedInformation.editCowFeed
                            ? Fluttertoast.showToast(
                            msg: 'Animal ID Cannot Be Edited')
                            : null;
                      },
                      controller: animalIdController,
                      firestore: firestore,
                      validatorText: 'Please Select Animal ID',
                      prefixIcon: Icon(
                        FontAwesomeIcons.paw, color: greenColor,),
                      suffixOnTap: (){
                    animalIdController.clear();
                      },
                      hintText: 'Animal ID (Cow)',
                      onSuggestionSelected: (val) {
                        animalIdController.text = val!;
                      },
                      onSuggestionCallback: (val) async {
                        List<String?> animalIdList = [];
                        await firestore.collection('Cows List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName).get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            if(AddCowFeedInformation.editCowFeed != true) {
                              animalIdList.add(doc['Animal Id']);
                            }
                          });
                        });
                        return animalIdList;
                      }),
                  //Stall No
                  MyTypeAhead(controller: stallNoController,
                      firestore: firestore,
                      validatorText: 'Please Select Stall No',
                      prefixIcon: Icon(
                        FontAwesomeIcons.building, color: greenColor,),
                      suffixOnTap: (){
                    stallNoController.clear();
                      },
                      hintText: 'Stall No',
                      onSuggestionSelected: (val) {
                        stallNoController.text = val!;
                      },
                      onSuggestionCallback: (val) async {
                        List<String?> stallNoList = [];
                        await firestore.collection('Stalls List')
                            .where('Farm Name', isEqualTo: Dashboard.farmName)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            stallNoList.add(doc['Stall']);
                          });
                        });
                        return stallNoList;
                      }),
                  //Grass Quantity
                  MyTextField(
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Grass (KG)',
                    hintIcon: const Icon(FontAwesomeIcons.bowlFood,
                        color: greenColor, size: 18.0),
                    controller: grassController,
                  ),
                  //Salt Quantity
                  MyTextField(
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Salt (KG)',
                    hintIcon: const Icon(FontAwesomeIcons.bowlFood,
                        color: greenColor, size: 18.0),
                    controller: saltController,
                  ),
                  //Water Quantity
                  MyTextField(
                    numberKeyboard: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field Cannot Be Empty';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Water (KG)',
                    hintIcon: const Icon(FontAwesomeIcons.bowlFood,
                        color: greenColor, size: 18.0),
                    controller: waterController,
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
                  //Feeding Time
                  MyTextField(
                    noKeyboard: true,
                    numberKeyboard: true,
                    onTap: ()async{
                      TimeOfDay? picker = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      setState(() {
                        feedingTimeController.text = picker!.format(context).toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select Time';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Feeding Time:',
                    hintIcon: const Icon(FontAwesomeIcons.clock,
                        color: greenColor, size: 18.0),
                    controller: feedingTimeController,
                  ),
                  //Feed Date
                  dateSelectionTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Date Date!';
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
      ),);
  }
}
