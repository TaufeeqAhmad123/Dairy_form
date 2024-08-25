import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Cow%20Feed/add_cow_feed_information.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';


class CowFeed extends StatefulWidget {
  static String id = 'CowFeed';

  @override
  State<CowFeed> createState() => _CowFeedState();
}

class _CowFeedState extends State<CowFeed> {

  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Cow Feed Information').doc(id).delete();
  }

  String? animalID;
  String? stallNo;
  String? grass;
  String? date;
  String? salt;
  String? water;
  String? note;
  String? feedingTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Cow Feed Information'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Cow Feed Information').snapshots(),
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
                        columnName: 'Stall No',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Animal ID (Cow)',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Grass (KG)',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Salt (KG)',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Water (KG)',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Feeding Time:',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Note:',
                        fontSize: fontSize,
                      ),StaffListColumn(
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
                salt = dataOfSnapshot.data()['Salt'];
                note = dataOfSnapshot.data()['Note:'];
                stallNo = dataOfSnapshot.data()['Stall No'];
                grass = dataOfSnapshot.data()['Grass'];
                feedingTime = dataOfSnapshot.data()['Feeding Time'];
                water = dataOfSnapshot.data()['Water'];
                date = dataOfSnapshot.data()['Date'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: stallNo),
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: grass),
                      StaffListColumn(columnName: salt),
                      StaffListColumn(columnName: water),
                      StaffListColumn(columnName: feedingTime),
                      StaffListColumn(columnName: note),
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
                            AddCowFeedInformation.editCowFeed= true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddCowFeedInformation(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                salt: dataOfSnapshot.data()['Salt'],
                                note: dataOfSnapshot.data()['Note:'],
                                stallNo: dataOfSnapshot.data()['Stall No'],
                                grass: dataOfSnapshot.data()['Grass'],
                                feedingTime: dataOfSnapshot.data()['Feeding Time'],
                                water: dataOfSnapshot.data()['Water'],
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
