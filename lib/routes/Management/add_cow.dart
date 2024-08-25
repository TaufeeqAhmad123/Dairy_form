import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';

import '../../constants/constants.dart';

class AddCow extends StatefulWidget {
  String? animalID;
  String? gender;
  String? animalType;
  String? buyDate;
  String? buyingPrice;
  String? pregnantStatus;
  String? milkPerDay;
  String? animalStatus;
  AddCow({
    this.animalID,
    this.gender,
    this.animalType,
    this.buyDate,
    this.buyingPrice,
    this.pregnantStatus,
    this.milkPerDay,
    this.animalStatus,
  });





  static String id = 'AddCow';
  static bool editCow = false;

  @override
  State<AddCow> createState() => _AddCowState();
}

class _AddCowState extends State<AddCow> {

  //Image Picker From Phone.
  ImagePicker _imagePicker = ImagePicker();
  XFile? profileImage;

  //Controllers Storing Data of Text Fields.
  TextEditingController animalIdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController animalTypeController = TextEditingController();
  final TextEditingController buyDateController = TextEditingController();
  final TextEditingController animalStatusController = TextEditingController();
  final TextEditingController buyingPriceController = TextEditingController();
  final TextEditingController milkPerDayController = TextEditingController();
  final TextEditingController pregnantStatusController = TextEditingController();


  //Filling TextFields Automatically If Edit Button Is Pressed On Cow List Screen
  editData() {
    animalIdController.text = widget.animalID!;
    genderController.text = widget.gender!;
    buyingPriceController.text = widget.buyingPrice!;
    animalTypeController.text = widget.animalType!;
    buyDateController.text = widget.buyDate!;
    pregnantStatusController.text = widget.pregnantStatus!;
    milkPerDayController.text = widget.milkPerDay!;
    animalStatusController.text = widget.animalStatus!;
  }

  @override
  void initState() {
    if (AddCow.editCow == true) {
      editData();
      super.initState();
    }
  }

    //Function To Avoid Adding Duplicate Data.
    Future<bool> doesEmailAlreadyExists(String dbEmail) async {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Cows List')
          .where('Animal Id', isEqualTo: animalIdController.text.toLowerCase())
          .limit(1)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      return documents.length == 1;
    }

    //Adding Data To Firebase
    final collection = FirebaseFirestore.instance.collection('Cows List');
    addData() async {
      collection.doc(animalIdController.text).set({
        "Animal Id": animalIdController.text.trim().toLowerCase(),
        "Gender": genderController.text.trim(),
        'Buying Price': buyingPriceController.text.trim(),
        "Animal Type": animalTypeController.text.trim(),
        "Buy Date": buyDateController.text.trim(),
        "Milk Per Day (LTR)": milkPerDayController.text.trim(),
        "Animal Status": animalStatusController.text.trim(),
        "Pregnant Status": pregnantStatusController.text.trim(),
        "Animal Image": profileImage?.path.trim(),
        "Farm Name": Dashboard.farmName
      });
    }

    // Clearing All TextFields.
    clearFields() {
      animalIdController.clear();
      genderController.clear();
      buyingPriceController.clear();
      animalTypeController.clear();
      buyDateController.clear();
      animalStatusController.clear();
      pregnantStatusController.clear();
      milkPerDayController.clear();
      setState(() {
        profileImage = null;
      });
    }

    //Updating Data
    updateData() {
      collection.doc(animalIdController.text).update({
        "Animal Id": animalIdController.text.trim(),
        "Gender": genderController.text.trim(),
        'Buying Price': buyingPriceController.text.trim(),
        "Animal Type": animalTypeController.text.trim(),
        "Buy Date": buyDateController.text.trim(),
        "Milk Per Day (LTR)": milkPerDayController.text.trim(),
        "Animal Status": animalStatusController.text.trim(),
        "Pregnant Status": pregnantStatusController.text.trim(),
        "Animal Image": profileImage?.path.trim()
      });
    }

    GlobalKey<FormState> key = GlobalKey();

    //Start of The Add Cow Screen
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: greenColor,
          centerTitle: true,
          title: const Text('Add Cow'),
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
                  //Checking if profile is added.
                  if (profileImage != null) {
                    //If Edit Data is Pressed Update the data.
                    if (AddCow.editCow == true) {
                      updateData();
                      Fluttertoast.showToast(
                          msg: "Data Updated Successfully!");
                      clearFields();
                      AddCow.editCow = false;
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
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please upload photo");
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
                    //Profile Image
                    InformationText('Animal Image'),
                    Container(
                      height: 200.0,
                      width: 200.0,
                      child: profileImage == null
                          ? Image.asset(
                        'images/dummyImage.png',
                      )
                          : Image.file(
                        File('${profileImage?.path}'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomButton(
                          icon: Icons.photo,
                          buttonName: 'Upload Image',
                          onPressed: () async {
                            profileImage = await _imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            setState(() {});
                          },
                        ),
                        //Animal Information
                        InformationText('Animal Information'),
                        //Data Texfields
                        //Animal Id
                        MyTextField(
                          numberKeyboard: true,
                          onTap: () =>
                          AddCow.editCow == true
                              ? Fluttertoast.showToast(
                              msg: 'Animal ID cannot be Edited!')
                              : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Animal ID cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          hintText: 'Animal ID',
                          hintIcon: const Icon(FontAwesomeIcons.paw,
                              color: greenColor, size: 18.0),
                          controller: animalIdController,
                          noKeyboard: AddCow.editCow == true ? true : false,
                        ),
                        //Buying Price
                        MyTextField(
                          numberKeyboard: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Buying Price Cannot Be Empty!';
                            } else {
                              return null;
                            }
                          },
                          hintText: 'Buying Price',
                          hintIcon: Icon(Icons.price_check_outlined,
                              color: greenColor),
                          controller: buyingPriceController,
                        ),
                        //Milk Per Day
                        MyTextField(
                          numberKeyboard: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Milk Per Day Field Cannot Be Empty';
                            } else {
                              return null;
                            }
                          },
                          hintText: 'Milk Per Day (LTR)',
                          hintIcon: Icon(FontAwesomeIcons.bucket,
                              color: greenColor),
                          controller: milkPerDayController,
                        ),
                        //Gender
                        MyDropdownButton(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please choose a Gender';
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Gender',
                            icon: Icon(
                              FontAwesomeIcons.cow,
                              color: greenColor,
                            ),
                            onChanged: (newValue) {
                              genderController.text = newValue;
                            },
                            dropDownList: [
                            
                              DropdownMenuItem(
                                child: Text('Female'),
                                value: 'Female',
                              ),
                            ]),
                        //Animal Type
                        MyDropdownButton(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please choose a Animal Type';
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Animal Type',
                            icon: Icon(
                              FontAwesomeIcons.cow,
                              color: greenColor,
                            ),
                            onChanged: (newValue) {
                              animalTypeController.text = newValue;
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
                        //Animal Status
                        MyDropdownButton(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please choose a Animal Status';
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Animal Status',
                            icon: Icon(
                              FontAwesomeIcons.cow,
                              color: greenColor,
                            ),
                            onChanged: (newValue) {
                              animalStatusController.text = newValue;
                            },
                            dropDownList: [
                              DropdownMenuItem(
                                child: Text('Sold'),
                                value: 'Sold',
                              ),
                              DropdownMenuItem(
                                child: Text('Available'),
                                value: 'Available',
                              ),
                            ]),
                        //Pregnant Status
                        MyDropdownButton(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please choose a Pregnant Status!';
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Pregnant Status',
                            icon: Icon(
                              Icons.bedroom_baby_outlined,
                              color: greenColor,
                            ),
                            onChanged: (newValue) {
                              pregnantStatusController.text = newValue;
                            },
                            dropDownList: [
                              DropdownMenuItem(
                                child: Text('Pregnant'),
                                value: 'Pregnant',
                              ),
                              DropdownMenuItem(
                                child: Text('Not Pregnant'),
                                value: 'Not Pregnant',
                              ),
                            ]),

                        //Buy Date
                        dateSelectionTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Select Buy Date!';
                              } else {
                                return null;
                              }
                            },
                            calendarDate: buyDateController,
                            hintText: 'Buy Date')
                      ],
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
