import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_routine_information.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';


class RoutineMonitor extends StatefulWidget {
  static String id = 'RoutineMonitor';

  @override
  State<RoutineMonitor> createState() => _RoutineMonitorState();
}

class _RoutineMonitorState extends State<RoutineMonitor> {

  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Routine Information').doc(id).delete();
  }

  String? animalID;
  String? stallNo;
  String? healthStatus;
  String? date;
  String? reportedBy;
  String? note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Routine Monitor'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Routine Information').snapshots(),
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
                        columnName: 'Animal ID (Cow)',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Stall No',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Note:',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Health Status',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Reported By',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Date',
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
                reportedBy = dataOfSnapshot.data()['Reported By'];
                note = dataOfSnapshot.data()['Note:'];
                stallNo = dataOfSnapshot.data()['Stall No'];
                healthStatus = dataOfSnapshot.data()['Health Status'];
                date = dataOfSnapshot.data()['Date'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: stallNo),
                      StaffListColumn(columnName: note),
                      StaffListColumn(columnName: healthStatus),
                      StaffListColumn(columnName: reportedBy),
                      StaffListColumn(columnName: date),
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
                            AddRoutineInformation.editRoutine= true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddRoutineInformation(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                healthStatus: dataOfSnapshot.data()['Health Status'],
                                note: dataOfSnapshot.data()['Note:'],
                                stallNo: dataOfSnapshot.data()['Stall No'],
                                reportedBy: dataOfSnapshot.data()['Reported By'],
                                date: dataOfSnapshot.data()['Date'],
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
