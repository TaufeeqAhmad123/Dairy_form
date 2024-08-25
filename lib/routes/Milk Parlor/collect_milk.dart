import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/add_milk_collection.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class CollectMilk extends StatefulWidget {
  static String id = 'CollectMilk';

  @override
  State<CollectMilk> createState() => _CollectMilkState();
}

class _CollectMilkState extends State<CollectMilk> {


  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Milk Collection').doc(id).delete();
  }

  String? animalID;
  String? stallNo;
  String? collectedBy;
  String? date;
  String? addedBy;
  String? accountNo;
  String? fat;
  String? milkLTR;
  String? price;
  String? total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Collect Milk'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Milk Collection').snapshots(),
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
                        columnName: 'Account No',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Stall No',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Animal ID',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Milk LTR',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Fat',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Price',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Total',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Date',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Collected By',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Added By',
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
                addedBy = dataOfSnapshot.data()['Added By'];
                fat = dataOfSnapshot.data()['Fat'];
                stallNo = dataOfSnapshot.data()['Stall No'];
                collectedBy = dataOfSnapshot.data()['Collected By'];
                milkLTR = dataOfSnapshot.data()['Milk LTR'];
                accountNo = dataOfSnapshot.data()['Account No'];
                price = dataOfSnapshot.data()['Price'];
                total = dataOfSnapshot.data()['Total'];
                date = dataOfSnapshot.data()['Date'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: accountNo),
                      StaffListColumn(columnName: stallNo, inContainer: true, containerColor: greenColor,),
                      StaffListColumn(columnName: animalID,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: milkLTR),
                      StaffListColumn(columnName: fat),
                      StaffListColumn(columnName: price),
                      StaffListColumn(columnName: total),
                      StaffListColumn(columnName: date),
                      StaffListColumn(columnName: collectedBy),
                      StaffListColumn(columnName: addedBy,inContainer: true, containerColor: greenColor,),
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
                                      deleteField(dataOfSnapshot.data()['Account No']);
                                      Fluttertoast.showToast(
                                          msg: '${dataOfSnapshot.data()['Account No'] +
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
                            AddMilkCollection.editMilkCollection = true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddMilkCollection(
                                animalID: dataOfSnapshot.data()['Animal Id'],
                                addedBy: dataOfSnapshot.data()['Added By'],
                                fat: dataOfSnapshot.data()['Fat'],
                                stallNo: dataOfSnapshot.data()['Stall No'],
                                collectedBy: dataOfSnapshot.data()['Collected By'],
                                milkLTR: dataOfSnapshot.data()['Milk LTR'],
                                accountNo: dataOfSnapshot.data()['Account No'],
                                date: dataOfSnapshot.data()['Date'],
                                price: dataOfSnapshot.data()['Price'],
                                total: dataOfSnapshot.data()['Total'],
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
