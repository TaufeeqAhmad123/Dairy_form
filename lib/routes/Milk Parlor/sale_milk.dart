import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khan_dairy/routes/Milk%20Parlor/add_milk_sale.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class SaleMilk extends StatefulWidget {
  static String id = 'SaleMilk';

  @override
  State<SaleMilk> createState() => _SaleMilkState();
}

class _SaleMilkState extends State<SaleMilk> {


  //Firebase Collection.
  final firestore = FirebaseFirestore.instance;

  deleteField(String id) {
    return firestore.collection('Milk Sale').doc(id).delete();
  }

  String? invoice;
  String? supplierName;
  String? email;
  String? date;
  String? soldBy;
  String? accountNo;
  String? phoneNumber;
  String? milkLTR;
  String? price;
  String? total;
  String? due;
  String? paid;
  String? salePrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Sale Milk'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(top: 20.0, bottom: 10, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Milk Sale').snapshots(),
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
                        columnName: 'Account No',
                        fontSize: fontSize,
                      ),
                      StaffListColumn(
                        columnName: 'Supplier Name',
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
                        columnName: 'Milk LTR',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Price',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Sale Price',
                        fontSize: fontSize,
                      ),StaffListColumn(
                        columnName: 'Total',
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
                        columnName: 'Sold By',
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
                soldBy = dataOfSnapshot.data()['Sold By'];
                phoneNumber = dataOfSnapshot.data()['Phone Number'];
                supplierName = dataOfSnapshot.data()['Supplier Name'];
                email = dataOfSnapshot.data()['Email'];
                milkLTR = dataOfSnapshot.data()['Milk LTR'];
                accountNo = dataOfSnapshot.data()['Account No'];
                price = dataOfSnapshot.data()['Price'];
                total = dataOfSnapshot.data()['Total'];
                date = dataOfSnapshot.data()['Date'];
                paid = dataOfSnapshot.data()['Paid'];
                due = dataOfSnapshot.data()['Due'];
                salePrice = dataOfSnapshot.data()['Sale Price'];

                if(dataOfSnapshot.data()['Farm Name'] == Dashboard.farmName)
                  stallsList.add(TableRow(
                    children: [
                      StaffListColumn(columnName: invoice,inContainer: true,containerColor: Colors.blueGrey.shade300),
                      StaffListColumn(columnName: accountNo),
                      StaffListColumn(columnName: supplierName),
                      StaffListColumn(columnName: phoneNumber),
                      StaffListColumn(columnName: email),
                      StaffListColumn(columnName: milkLTR),
                      StaffListColumn(columnName: price),
                      StaffListColumn(columnName: salePrice),
                      StaffListColumn(columnName: total,inContainer: true, containerColor: greenColor,),
                      StaffListColumn(columnName: paid,inContainer: true, containerColor: Colors.orangeAccent,),
                      StaffListColumn(columnName: due,inContainer: true, containerColor: Colors.redAccent,),
                      StaffListColumn(columnName: date),
                      StaffListColumn(columnName: soldBy),
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
                            AddMilkSale.editMilkSale = true;
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return AddMilkSale(
                                invoice: dataOfSnapshot.data()['Invoice'],
                                soldBy: dataOfSnapshot.data()['Sold By'],
                                phoneNumber: dataOfSnapshot.data()['Phone Number'],
                                email: dataOfSnapshot.data()['Email'],
                                supplierName: dataOfSnapshot.data()['Supplier Name'],
                                milkLTR: dataOfSnapshot.data()['Milk LTR'],
                                accountNo: dataOfSnapshot.data()['Account No'],
                                date: dataOfSnapshot.data()['Date'],
                                milkPrice: dataOfSnapshot.data()['Price'],
                                total: dataOfSnapshot.data()['Total'],
                                paid: dataOfSnapshot.data()['Paid'],
                                due: dataOfSnapshot.data()['Due'],
                                salePrice: dataOfSnapshot.data()['Sale Price'],
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
