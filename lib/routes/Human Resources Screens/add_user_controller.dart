import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddUserController {

  //Constructor to Fetch Data If Edit Is Pressed.
  String? name;
  String? email;
  String? phone;
  String? address;
  String? password;
  String? userType;
  String? calendarDate;
  AddUserController({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.password,
    this.userType,
    this.calendarDate,
  });

  //Controllers Storing Data of Text Fields.
  TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final MultiValueDropDownController userTypeController = MultiValueDropDownController();
  final TextEditingController calendarDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  //Image Picker From Phone Gallery.
  ImagePicker imagePicker = ImagePicker();
  XFile? profileImage;


  //Filling TextFields Automatically If Edit Button Is Pressed.
  editData(){
    nameController.text = name!;
    emailController.text = email!;
    passwordController.text = password!;
    phoneController.text = phone!;
    addressController.text = address!;
    userType = userType;
    calendarDateController.text = calendarDate!;
  }

  //Adding Data To Firebase
  final collection = FirebaseFirestore.instance.collection('Staff List');
  addData() async {
    collection.doc(emailController.text).set({
      "Name": nameController.text.trim(),
      "Email": emailController.text.trim().toLowerCase(),
      'Password': passwordController.text.trim(),
      "Phone": phoneController.text.trim(),
      "Address": addressController.text.trim(),
      "Calendar Date": calendarDateController.text.trim(),
      "User Type": userType,
      "Profile Image": profileImage?.path.trim()
    });
  }

  //Updating Data If Edit Is Pressed.
  updateData(){
    print('Update Data');
    collection.doc(emailController.text).update({
      "Name": nameController.text.trim(),
      "Email": emailController.text.trim().toLowerCase(),
      'Password': passwordController.text.trim(),
      "Phone": phoneController.text.trim(),
      "Address": addressController.text.trim(),
      "User Type": userType,
      "Calendar Date": calendarDateController.text.trim(),
      "Profile Image": profileImage?.path.trim()
    });
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

  clearFields(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    addressController.clear();
    userType = null;
    calendarDateController.clear();
      profileImage = null;
  }

}