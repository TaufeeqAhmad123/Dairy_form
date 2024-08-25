import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddSupplier extends StatefulWidget {
  String? supplierName;
  String? email;
  String? companyName;
  String? phoneNumber;

  AddSupplier({this.supplierName,this.email,this.companyName,this.phoneNumber});


  static String id = 'AddSuppliers';
  static bool editSupplier = false;

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {

  //Text Field Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Staff List Screen
  editData(){
    supplierNameController.text = widget.supplierName!;
    emailController.text = widget.email!;
    companyNameController.text = widget.companyName!;
    phoneNumberController.text = widget.phoneNumber!;
  }
  @override
  void initState() {
    if(AddSupplier.editSupplier == true){
      editData();
    }super.initState();
  }


  //Updating Data
  updateData(){
    firestore..collection('Suppliers List').doc(supplierNameController.text).update({
      "Email": emailController.text.trim(),
      'Supplier Name': supplierNameController.text.trim(),
      "Company Name": companyNameController.text.trim(),
      'Phone Number': phoneNumberController.text.trim(),
    });
    clearFields();
  }


  //Adding Data To Firebase
  final firestore = FirebaseFirestore.instance;
  addData() async {
    print('Added Data');
    final collection =
    await FirebaseFirestore.instance.collection('Suppliers List');
    collection.doc(supplierNameController.text).set({
      'Email': emailController.text.trim(),
      'Supplier Name': supplierNameController.text.trim(),
      'Company Name': companyNameController.text.trim(),
      'Phone Number': phoneNumberController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
    clearFields();
  }

  //Clearing Fields
  clearFields() {
    emailController.clear();
    supplierNameController.clear();
    companyNameController.clear();
    phoneNumberController.clear();
  }

  //Avoiding Duplicate Data;
  Future<bool> doesEmailExists(String dbEmail) async {
    final QuerySnapshot results = await FirebaseFirestore.instance
        .collection('Suppliers List')
        .where('Supplier Name', isEqualTo: supplierNameController.text)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = results.docs;
    return documents.length == 1;
  }

//Globar Key For Validation
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AddSupplier.editSupplier = false;}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Supplier'),
        //Button To Add Data To Firebase
        actions: [
          GestureDetector(
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tap To Save Information"),
              ));
            },
            onTap: () async {
              if (key.currentState!.validate()) {

                //If Edit Data is Pressed Update the data.
                if(AddSupplier.editSupplier == true){
                  updateData();
                  Fluttertoast.showToast(
                      msg: "Data Updated Successfully!");
                  clearFields();
                  AddSupplier.editSupplier = false;
                }
                //Checking If Data Already Exists
                if (await doesEmailExists(
                    supplierNameController.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg:
                      'Supplier Name Already Exists!');
                } else {

                  //Adding Data
                  addData();
                  Fluttertoast.showToast(msg: 'Data Added Successfully!');
                  // clearFields();
                  setState(() {});
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
          child: Padding(
              padding: const EdgeInsets.only(top:20, bottom: 10 , left:10, right: 10),
              child: Column(
                children: [
                  //Supplier Name
                  MyTextField(
                    onTap: (){
                      if(AddSupplier.editSupplier == true){
                        Fluttertoast.showToast(msg: 'Supplier Cannot Be Edited!');
                      }
                    },

                    noKeyboard: AddSupplier.editSupplier == true ? true: false,
                    hintIcon: Icon(
                      Icons.boy_outlined,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Supplier Name Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Supplier Name',
                    controller: supplierNameController,
                  ),
                  //Company Name
                  MyTextField(
                    hintIcon: Icon(
                      FontAwesomeIcons.building,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Company Name Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Company Name',
                    controller: companyNameController,
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
                ],
              )),
        ),
      ),
    );
  }
}
