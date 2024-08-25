import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Management/add_stall.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class ManageStalls extends StatefulWidget {
  static String id = 'ManageStall';

  @override
  State<ManageStalls> createState() => _ManageStallsState();
}

class _ManageStallsState extends State<ManageStalls> {
  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Stalls List').doc(id).delete();
  }

  String? stall;
  String? status;
  String? details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Stalls List'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Stalls List').snapshots(),
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
                        columnName: 'Stall',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Status',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Details',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Action',
                        fontSize: fontSize,
                      ),
                    ]),
              ];

              dynamic data = snapshot.data?.docs;
              for (var dataOfSnapshots in data) {
                stall = dataOfSnapshots.data()['Stall'];
                status = dataOfSnapshots.data()['Status'];
                details = dataOfSnapshots.data()['Details'];

                if(dataOfSnapshots.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(children: [
                  StaffListColumn(columnName: stall),
                  StaffListColumn(
                    columnName: status,
                    inContainer: true,
                    containerColor: status == 'Available' ? greenColor: Colors.red,
                  ),
                  StaffListColumn(columnName: details),
                  EditAndDeleteButton(onTapDelete: () {
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Warning!'),
                              content: Text(
                                  'Are you sure you want to delete this information?'),
                              actions: [
                                CustomButton(
                                  buttonName: 'Delete',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteField(
                                        dataOfSnapshots.data()['Stall']);
                                    Fluttertoast.showToast(
                                        msg:
                                            '${dataOfSnapshots.data()['Stall'] + ' Deleted'}');
                                  },
                                ),
                                CustomButton(
                                    buttonName: 'Cancel',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ],
                            );
                          });
                    });
                  }, onTapEdit: () {
                    AddStall.editStall = true;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddStall(
                        stall: dataOfSnapshots.data()['Stall'],
                        status: dataOfSnapshots.data()['Status'],
                        details: dataOfSnapshots.data()['Details'],
                      );
                    }));
                  }),
                ]));
              }
              return CustomTableRowDesign(
                  customColumnWidths: {0: FixedColumnWidth(150)},
                  children: stallsList);
            }),
      ),
    );
  }
}
