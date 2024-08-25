import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class AddStall extends StatefulWidget {
  String? stall;
  String? status;
  String? details;

  AddStall({this.stall,this.status,this.details});


  static String id = 'AddStall';
  static bool editStall = false;

  @override
  State<AddStall> createState() => _AddStallState();
}

class _AddStallState extends State<AddStall> {

  //Text Field Controllers
  final TextEditingController statusController = TextEditingController();
  final TextEditingController stallcontroller = TextEditingController();
  final TextEditingController detailsController =
  TextEditingController();

  //Filling TextFields Automatically If Edit Button Is Pressed On Staff List Screen
  editData(){
    stallcontroller.text = widget.stall!;
    statusController.text = widget.status!;
    detailsController.text = widget.details!;
  }
  @override
  void initState() {
    if(AddStall.editStall == true){
      editData();
    }else{
    }
    super.initState();
  }


  //Updating Data
  updateData(){
    firestore..collection('Stalls List').doc(stallcontroller.text).update({
      "Status": statusController.text.trim(),
      'Stall': stallcontroller.text.trim(),
      "Details": detailsController.text.trim(),
    });
    clearFields();
  }


  //Adding Data To Firebase
  final firestore = FirebaseFirestore.instance;

  addData() async {
    print('Added Data');
    final collection =
    await FirebaseFirestore.instance.collection('Stalls List');
    collection.doc(stallcontroller.text).set({
      'Status': statusController.text.trim(),
      'Stall': stallcontroller.text.trim(),
      'Details': detailsController.text.trim(),
      "Farm Name": Dashboard.farmName
    });
    clearFields();
  }

  //Clearing Fields
  clearFields() {
    statusController.clear();
    stallcontroller.clear();
    detailsController.clear();
    setState(() {});
  }

  //Avoiding Duplicate Data;
  Future<bool> doesEmailExists(String dbEmail) async {
    final QuerySnapshot results = await FirebaseFirestore.instance
        .collection('Stalls List')
        .where('Stall', isEqualTo: stallcontroller.text)
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
    AddStall.editStall = false;}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Add Stall'),
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
                if(AddStall.editStall == true){
                  updateData();
                  Fluttertoast.showToast(
                      msg: "Data Updated Successfully!");
                  // clearFields();
                  AddStall.editStall = false;
                }
                //Checking duplicate email.
                //Checking If Data Already Exists
                if (await doesEmailExists(
                    stallcontroller.text.toLowerCase())) {
                  Fluttertoast.showToast(
                      msg:
                      'Stall Already Exists!');
                } else {
                  //Adding Data
                  addData();
                  Fluttertoast.showToast(msg: 'Stall Added Successfully!');
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
          child: Padding(
              padding: const EdgeInsets.only(top:20, bottom: 10 , left:10, right: 10),
              child: Column(
                children: [
                  MyTextField(
                    onTap: (){
                      if(AddStall.editStall == true){
                        Fluttertoast.showToast(msg: 'Stall Cannot Be Edited!');
                      }
                    },
                    noKeyboard: AddStall.editStall == true ? true: false,
                    hintIcon: Icon(
                      Icons.warehouse_outlined,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Stall Cannot Be Empty!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Stall Name\/Number',
                    controller: stallcontroller,
                  ),
                  MyDropdownButton(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose Status!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Status',
                      icon: Icon(
                        FontAwesomeIcons.checkToSlot,
                        color: greenColor,
                      ),
                      onChanged: (newValue) {
                        statusController.text = newValue;
                      },
                      dropDownList: [
                        DropdownMenuItem(
                          child: Text('Available'),
                          value: 'Available',
                        ),
                        DropdownMenuItem(
                          child: Text('Booked'),
                          value: 'Booked',
                        ),
                      ]),
                  MyTextField(
                    hintIcon: Icon(
                      Icons.note_alt_outlined,
                      color: greenColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Put Some Details!';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Details',
                    controller: detailsController,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
