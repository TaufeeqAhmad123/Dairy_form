import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_vaccine_information.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';


class VaccineMonitor extends StatefulWidget {
  static String id = 'VaccineMonitor';

  @override
  State<VaccineMonitor> createState() => _VaccineMonitorState();
}

class _VaccineMonitorState extends State<VaccineMonitor> {

  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Vaccine Information').doc(id).delete();
  }

  String? animalID;
  String? stallNo;
  String? vaccineName;
  String? date;
  String? reportedBy;
  String? note;
  String? dose;
  String? givenTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Vaccine Monitor'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Vaccine Information').snapshots(),
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
                        columnName: 'Vaccine Name',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Dose',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Note:',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Given Time:',
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
                vaccineName = dataOfSnapshot.data()['Vaccine Name'];
                date = dataOfSnapshot.data()['Date'];
                givenTime = dataOfSnapshot.data()['Given Time'];
                dose = dataOfSnapshot.data()['Dose'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: stallNo),
                      StaffListColumn(columnName: vaccineName),
                      StaffListColumn(columnName: dose),
                      StaffListColumn(columnName: note),
                      StaffListColumn(columnName: givenTime),
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
                            AddVaccineInformation.editVaccine= true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddVaccineInformation(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                vaccineName: dataOfSnapshot.data()['Vaccine Name'],
                                note: dataOfSnapshot.data()['Note:'],
                                stallNo: dataOfSnapshot.data()['Stall No'],
                                reportedBy: dataOfSnapshot.data()['Reported By'],
                                date: dataOfSnapshot.data()['Date'],
                                dose: dataOfSnapshot.data()['Dose'],
                                givenTime: dataOfSnapshot.data()['Given Time'],
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
