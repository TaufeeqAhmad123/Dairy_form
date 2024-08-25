import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Suppliers/add_suppliers.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class SuppliersList extends StatefulWidget {
  static String id = 'SupplierList';

  @override
  State<SuppliersList> createState() => _SuppliersListState();
}

class _SuppliersListState extends State<SuppliersList> {
  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Suppliers List').doc(id).delete();}

  String? supplierName;
  String? companyName;
  String? email;
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Suppliers List'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Suppliers List').snapshots(),
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
                        columnName: 'Name',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Company',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Phone Number',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Email',
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
                supplierName = dataOfSnapshots.data()['Supplier Name'];
                companyName = dataOfSnapshots.data()['Company Name'];
                email = dataOfSnapshots.data()['Email'];
                phoneNumber = dataOfSnapshots.data()['Phone Number'];

                if(dataOfSnapshots.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(children: [
                  StaffListColumn(columnName: supplierName),
                  StaffListColumn(columnName: companyName),
                  StaffListColumn(columnName: phoneNumber),
                  StaffListColumn(columnName: email),
                  EditAndDeleteButton(
                      onTapDelete: () {
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
                                        dataOfSnapshots.data()['Supplier Name']);
                                    Fluttertoast.showToast(
                                        msg:
                                        '${dataOfSnapshots.data()['Supplier Name'] + ' Deleted'}');
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
                  },
                      onTapEdit: () {
                    AddSupplier.editSupplier = true;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return AddSupplier(
                            supplierName: dataOfSnapshots.data()['Supplier Name'],
                            companyName: dataOfSnapshots.data()['Company Name'],
                            email: dataOfSnapshots.data()['Email'],
                            phoneNumber: dataOfSnapshots.data()['Phone Number'],
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
