import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Cow%20Sale/add_cow_sale_information.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class CowSale extends StatefulWidget {
  static String id = 'CowSale';

  @override
  State<CowSale> createState() => _CowSaleState();
}

class _CowSaleState extends State<CowSale> {


  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Cow Sale').doc(id).delete();
  }

  String? invoice;
  String? animalId;
  String? email;
  String? date;
  String? customerNmae;
  String? phoneNumber;
  String? price;
  String? due;
  String? paid;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Cow Sale'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Cow Sale').snapshots(),
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
                        columnName: 'Invoice',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Animal ID',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Customer Name',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Phone Number',
                        fontSize: fontSize,),
                      StaffListColumn(
                        columnName: 'Email',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Address',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Price',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Paid',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Due',
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
                invoice = dataOfSnapshot.data()['Invoice'];
                customerNmae = dataOfSnapshot.data()['Customer Name'];
                phoneNumber = dataOfSnapshot.data()['Phone Number'];
                animalId = dataOfSnapshot.data()['Animal Id'];
                email = dataOfSnapshot.data()['Email'];
                price = dataOfSnapshot.data()['Price'];
                date = dataOfSnapshot.data()['Date'];
                paid = dataOfSnapshot.data()['Paid'];
                due = dataOfSnapshot.data()['Due'];
                address = dataOfSnapshot.data()['Address'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: invoice,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: animalId,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: customerNmae),
                      StaffListColumn(columnName: phoneNumber),
                      StaffListColumn(columnName: address),
                      StaffListColumn(columnName: email),
                      StaffListColumn(columnName: price,inContainer: true,containerColor: greenColor,),
                      StaffListColumn(columnName: paid,inContainer: true, containerColor: Colors.orangeAccent,),
                      StaffListColumn(columnName: due,inContainer: true, containerColor: Colors.redAccent,),
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
                                      deleteField(dataOfSnapshot.data()['Invoice']);
                                      Fluttertoast.showToast(
                                          msg: '${dataOfSnapshot.data()['Invoice'] +
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
                            AddCowSaleInformation.editCowSale = true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddCowSaleInformation(
                                invoice: dataOfSnapshot.data()['Invoice'],
                                address: dataOfSnapshot.data()['Address'],
                                phoneNumber: dataOfSnapshot.data()['Phone Number'],
                                email: dataOfSnapshot.data()['Email'],
                                customerName: dataOfSnapshot.data()['Customer Name'],
                                date: dataOfSnapshot.data()['Date'],
                                price: dataOfSnapshot.data()['Price'],
                                paid: dataOfSnapshot.data()['Paid'],
                                due: dataOfSnapshot.data()['Due'],
                                animalId: dataOfSnapshot.data()['Animal Id'],
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
