import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';
import 'add_calf.dart';

class ManageCalf extends StatefulWidget {
  static String id = 'ManageCalf';

  @override
  State<ManageCalf> createState() => _ManageCalfState();
}

class _ManageCalfState extends State<ManageCalf> {

  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Calves List').doc(id).delete();
  }

  String? animalID;
  String? gender;
  String? animalType;
  String? buyDate;
  String? buyingPrice;
  String? motherId;
  String? animalStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Calves List'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Calves List').snapshots(),
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
                        columnName: 'Mother ID',
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
                gender = dataOfSnapshot.data()['Gender'];
                animalType = dataOfSnapshot.data()['Animal Type'];
                animalStatus = dataOfSnapshot.data()['Animal Status'];
                motherId = dataOfSnapshot.data()['Mother Id'];
                buyDate = dataOfSnapshot.data()['Buy Date'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: buyingPrice),
                      StaffListColumn(columnName: motherId,inContainer: true, containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: gender),
                      StaffListColumn(columnName: animalType,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: animalStatus,inContainer: true,containerColor: animalStatus == 'Sold' ? Colors.orangeAccent: greenColor),
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
                            AddCalf.editCalf = true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddCalf(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                buyingPrice: dataOfSnapshot.data()['Buying Price'],
                                gender: dataOfSnapshot.data()['Gender'],
                                animalType: dataOfSnapshot.data()['Animal Type'],
                                animalStatus: dataOfSnapshot.data()['Animal Status'],
                                motherId: dataOfSnapshot.data()['Mother Id'],
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
