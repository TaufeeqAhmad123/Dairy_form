import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddUser extends StatefulWidget {

  //Constructor to Fetch Data If Edit Is Pressed.
  String? name;
  String? email;
  String? phone;
  String? address;
  String? password;
  String? userType;
  String? calendarDate;
  AddUser({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.password,
    this.userType,
    this.calendarDate,
  });





  static String id = 'AddStaff';

  //If Edit Data Is Pressed.
  static bool editStaff = false;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  //Image Picker From Phone Gallery.
  ImagePicker _imagePicker = ImagePicker();
  XFile? profileImage;

  //Controllers Storing Data of Text Fields.
   TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final MultiValueDropDownController userTypeController = MultiValueDropDownController();
  final TextEditingController calendarDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

   //Filling TextFields Automatically If Edit Button Is Pressed.
   editData(){
    nameController.text = widget.name!;
    emailController.text = widget.email!;
    passwordController.text = widget.password!;
    phoneController.text = widget.phone!;
    addressController.text = widget.address!;
    userTypeValue = widget.userType;
    calendarDateController.text = widget.calendarDate!;
  }
  
  @override
  void initState() {
    super.initState();
    if(AddUser.editStaff == true){
      editData();
    }
  }

  //Updating Data If Edit Is Pressed.
  updateData(){
    collection.doc(emailController.text).update({
      "Name": nameController.text.trim(),
      "Email": emailController.text.trim().toLowerCase(),
      'Password': passwordController.text.trim(),
      "Phone": phoneController.text.trim(),
      "Address": addressController.text.trim(),
      "User Type": userTypeValue,
      "Calendar Date": calendarDateController.text.trim(),
      "Profile Image": profileImage?.path.trim(),
    });
    clearFields();
  }

  //Function To Avoid Adding Duplicate Data.
  Future<bool> doesEmailAlreadyExists(String dbEmail) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Staff List')
        .where('Email', isEqualTo: emailController.text.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Adding Data To Firebase
  final collection = FirebaseFirestore.instance.collection('Staff List');
  addData() async {
    print('Adding Data');
    collection.doc(emailController.text).set({
      "Name": nameController.text.trim(),
      "Email": emailController.text.trim().toLowerCase(),
      'Password': passwordController.text.trim(),
      "Phone": phoneController.text.trim(),
      "Address": addressController.text.trim(),
      "User Type": userTypeValue,
      "Calendar Date": calendarDateController.text.trim(),
      "Profile Image": profileImage?.path.trim(),
      "Farm Name": Dashboard.farmName?.trim(),
    });
    clearFields();
  }

  //Function To Clear All TextFields After Data Is Added Or Updated.
  clearFields(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    addressController.clear();
    userTypeValue = null;
    calendarDateController.clear();
    setState(() {
      profileImage = null;
    });
  }

  //Holds User Type Value.
  String? userTypeValue;

  //Password Visibility.
  bool passwordVisibility = true;

  //Global Key For Validation Of Text Fields.
  GlobalKey<FormState> key = GlobalKey();


  Future<bool> registerUser({required BuildContext context}) async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Succeessfully Registered In"),

    ));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
      ));
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      return false;

    }
  }


  addUserData(){
    final firestore = FirebaseFirestore.instance;
    print('Adding Data');
    firestore.collection('Users').doc(emailController.text)
        .set({
      'Name': nameController.text.trim(),
      'Phone': phoneController.text.trim(),
      'Email': emailController.text.trim(),
      'Farm Name': Dashboard.farmName,
      'Password': passwordController.text.trim(),
    });
  }


  //Start of The Add User Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add New User'),
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
                if(profileImage != null) {

                  //If Edit Data is Pressed Update the data.
                  if(AddUser.editStaff == true){
                    updateData();
                    Fluttertoast.showToast(
                        msg: "Data Updated Successfully!");
                    // clearFields();
                    AddUser.editStaff = false;
                  }

                  //Checking duplicate email.
                  else if (await doesEmailAlreadyExists(emailController.text.toLowerCase())) {
                    Fluttertoast.showToast(
                        msg: "Email already exists. Please use another!");

                  }else {
                    //Adding Data To Firebase.
                    addData();
                    Fluttertoast.showToast(
                        msg: "New Staff Added Successfully!");
                    if (
                    await registerUser(
                      context: context,
                    )) {
                      print('User Registered');
                      addUserData();
                      print('Signing Out New User');
                      FirebaseAuth.instance.signOut();
                      print('Signing In Old User');
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: Registration.email!,
                          password: Registration.password!);
                    } else {print('Error While Registering');}
                  }
                }else{
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
                  InformationText('Staff Image'),
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
                    children: ([
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

                      //Staff Information
                      InformationText('Staff Information'),
                      //Data Text Fields

                      //Name
                      MyTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'Name',
                        hintIcon: const Icon(FontAwesomeIcons.user,
                            color: greenColor, size: 18.0),
                        controller: nameController,
                      ),

                      //Email
                      MyTextField(
                        onTap: () => AddUser.editStaff == true ? Fluttertoast.showToast(msg: 'Email cannot be Edited!'): null,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'Email',
                        hintIcon: Icon(Icons.email_outlined, color: greenColor),
                        controller: emailController,
                        noKeyboard: AddUser.editStaff,
                      ),

                      //Password
                      MyTextField(
                        validator: (value) {
                          if (value == null ||
                              passwordController.text.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (passwordVisibility == true) {
                                passwordVisibility = false;
                              } else {
                                passwordVisibility = true;
                              }
                            });
                          },
                          icon: passwordVisibility
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                ),
                        ),
                        passwordHide: passwordVisibility,
                        hintText: 'Password',
                        hintIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: greenColor,
                        ),
                        controller: passwordController,
                      ),

                      //Phone
                      MyTextField(
                        validator: (value) {
                          if (value == null ||
                              phoneController.text.length < 11) {
                            return 'Enter valid phone number';
                          } else {
                            return null;
                          }
                        },
                        numberKeyboard: true,
                        hintText: 'Phone',
                        hintIcon: Icon(Icons.phone, color: greenColor),
                        controller: phoneController,
                      ),

                      //Address
                      MyTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'Address',
                        hintIcon: Icon(Icons.house_outlined, color: greenColor),
                        controller: addressController,
                      ),

                      //User Type
                      MyDropdownButton(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose a User Type';
                            } else {
                              return null;
                            }
                          },
                          hintText: 'User Type',
                          icon: Icon(
                            FontAwesomeIcons.userAstronaut,
                            color: greenColor,
                          ),
                          onChanged: (newValue) {
                            userTypeValue = newValue;
                          },
                          dropDownList: [
                            DropdownMenuItem(
                              child: Text('Admin'),
                              value: 'Admin',
                            ),
                            DropdownMenuItem(
                              child: Text('Accountant'),
                              value: 'Accountant',
                            ),
                            DropdownMenuItem(
                              child: Text('Executive'),
                              value: 'Executive',
                            ),
                            DropdownMenuItem(child: Text('Staff'),value: 'Staff',)
                          ]),

                      //Joining Date
                      dateSelectionTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Select Joining Date';
                            } else {
                              return null;
                            }
                          },
                          calendarDate: calendarDateController,
                          hintText: 'Joining Date')
                    ]),
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
