import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Cow%20Monitor/add_animal_pregnancy_information.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';


class AnimalPregnancy extends StatefulWidget {
  static String id = 'AnimalPregnancy';

  @override
  State<AnimalPregnancy> createState() => _AnimalPregnancyState();
}

class _AnimalPregnancyState extends State<AnimalPregnancy> {

  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Animal Pregnancy').doc(id).delete();
  }

  String? animalID;
  String? stallNo;
  String? pregnancyType;
  String? pregnancyDate;
  String? semenType;
  String? note;
  String? deliveryTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Pregnancy Monitor'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Animal Pregnancy').snapshots(),
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
                        columnName: 'Pregnancy Type',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Semen Type',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Note:',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Pregnancy Start',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Delivery Time:',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Action',
                        fontSize: fontSize,
                      ),
                    ]),
              ];

              dynamic data = snapshot.data?.docs;
              for (var dataOfSnapshot in data) {
                animalID = dataOfSnapshot.data()['Animal Id'];
                semenType = dataOfSnapshot.data()['Semen Type'];
                note = dataOfSnapshot.data()['Note:'];
                stallNo = dataOfSnapshot.data()['Stall No'];
                pregnancyType = dataOfSnapshot.data()['Pregnancy Type'];
                pregnancyDate = dataOfSnapshot.data()['Pregnancy Date'];
                deliveryTime = dataOfSnapshot.data()['Delivery Time'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: stallNo),
                      StaffListColumn(columnName: pregnancyType),
                      StaffListColumn(columnName: semenType),
                      StaffListColumn(columnName: note),
                      StaffListColumn(columnName: pregnancyDate),
                      StaffListColumn(columnName: deliveryTime),
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
                            AddAnimalPregnancyInformation.editPregnancy= true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddAnimalPregnancyInformation(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                pregnancyType: dataOfSnapshot.data()['Pregnancy Type'],
                                note: dataOfSnapshot.data()['Note:'],
                                stallNo: dataOfSnapshot.data()['Stall No'],
                                semenType: dataOfSnapshot.data()['Semen Type'],
                                pregnancyStartDate: dataOfSnapshot.data()['Pregnancy Date'],
                                deliveryTime: dataOfSnapshot.data()['Delivery Time'],
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
