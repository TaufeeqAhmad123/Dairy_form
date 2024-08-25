import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';
import 'add_cow.dart';

class ManageCow extends StatefulWidget {
  static String id = 'ManageCow';

  @override
  State<ManageCow> createState() => _ManageCowState();
}

class _ManageCowState extends State<ManageCow> {
  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Cows List').doc(id).delete();
  }

  String? animalID;
  String? gender;
  String? animalType;
  String? buyDate;
  String? buyingPrice;
  String? pregnantStatus;
  String? milkPerDay;
  String? animalStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Cows List'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Cows List').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ));
              }
              List<TableRow> stallsList = [
                TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    children: [
                      StaffListColumn(
                        columnName: 'Animal ID',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Buying Price',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Milk Par Day',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Gender',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Animal Type',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Animal Status',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Pregnant Status',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Buy Date',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Action',
                        fontSize: fontSize,
                      ),
                    ]),
              ];

              dynamic data = snapshot.data?.docs;
              for (var dataOfSnapshot in data) {
                animalID = dataOfSnapshot.data()['Animal Id'];
                buyingPrice = dataOfSnapshot.data()['Buying Price'];
                milkPerDay = dataOfSnapshot.data()['Milk Per Day (LTR)'];
                gender = dataOfSnapshot.data()['Gender'];
                animalType = dataOfSnapshot.data()['Animal Type'];
                animalStatus = dataOfSnapshot.data()['Animal Status'];
                pregnantStatus = dataOfSnapshot.data()['Pregnant Status'];
                buyDate = dataOfSnapshot.data()['Buy Date'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: buyingPrice),
                      StaffListColumn(columnName: milkPerDay),
                      StaffListColumn(columnName: gender),
                      StaffListColumn(columnName: animalType,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: animalStatus,inContainer: true,containerColor: animalStatus == 'Sold' ? Colors.orangeAccent: greenColor),
                      StaffListColumn(columnName: pregnantStatus,inContainer: true,containerColor: pregnantStatus == 'Not Pregnant' ? Colors.orangeAccent: greenColor),
                      StaffListColumn(columnName: buyDate),
                      EditAndDeleteButton(
                          onTapDelete: () {
                            setState(() {
                              showDialog(context: context, builder: (
                                  BuildContext context) {
                                return AlertDialog(
                                  title: Text('Warning!'),
                                  content: Text(
                                      'Are you sure you want to delete this information?'),
                                  actions: [
                                    CustomButton(buttonName: 'Delete', onPressed: () {
                                      Navigator.pop(context);
                                      deleteField(dataOfSnapshot.data()['Animal Id']);
                                      Fluttertoast.showToast(
                                          msg: '${dataOfSnapshot.data()['Animal Id'] +
                                              ' Deleted'}');
                                    },),
                                    CustomButton(buttonName: 'Cancel', onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                  ],
                                );
                              });
                            });
                          },
                          onTapEdit: () {
                            AddCow.editCow = true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddCow(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                buyingPrice: dataOfSnapshot.data()['Buying Price'],
                                milkPerDay: dataOfSnapshot.data()['Milk Per Day (LTR)'],
                                gender: dataOfSnapshot.data()['Gender'],
                                animalType: dataOfSnapshot.data()['Animal Type'],
                                animalStatus: dataOfSnapshot.data()['Animal Status'],
                                pregnantStatus: dataOfSnapshot.data()['Pregnant Status'],
                                buyDate: dataOfSnapshot.data()['Buy Date'],
                              );
                            }));
                          }

                      ),
                    ]));
              }
              return CustomTableRowDesign(
                  children: stallsList);
            }),
      ),
    );
  }
}
