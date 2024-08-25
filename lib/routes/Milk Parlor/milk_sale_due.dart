// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';

import '../../constants/constants.dart';

class MilkSaleDue extends StatefulWidget {
  static String id = 'MilkSaleDue';

  @override
  State<MilkSaleDue> createState() => _MilkSaleDueState();
}

class _MilkSaleDueState extends State<MilkSaleDue> {
  String? invoice = '';

  String? date = '';

  String? total = '';

  String? paid = '';

  String? due = '';

  //Controllers
  TextEditingController invoiceController = TextEditingController();

  //Firebase Instance
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: greenColor,
          centerTitle: true,
          title: const Text('Milk Sale Due'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyTypeAhead(
                  controller: invoiceController,
                  firestore: firestore,
                  validatorText: 'Please Select Invoice',
                  prefixIcon: Icon(
                    Icons.library_add_check_outlined,
                    color: greenColor,
                  ),
                  suffixOnTap: () => invoiceController.clear(),
                  hintText: 'Invoice',
                  onSuggestionSelected: (val) async {
                    invoiceController.text = val!;
                    await firestore
                        .collection('Milk Sale')
                        .doc(val)
                        .get()
                        .then((snapshot) {
                      invoice = snapshot['Invoice'];
                      date = snapshot['Date'];
                      total = snapshot['Total'];
                      paid = snapshot['Paid'];
                      due = snapshot['Due'];
                      setState(() {});
                    });
                  },
                  onSuggestionCallback: (val) async {
                    List<String?> invoiceList = [];
                    await firestore
                        .collection('Milk Sale').where('Farm Name', isEqualTo: Dashboard.farmName)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        invoiceList.add(doc['Invoice']);
                      });
                    });
                    return invoiceList;
                  }),
              SizedBox(
                height: 20,
              ),
              CustomTableRowDesign(children: [
                TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    children: [
                      StaffListColumn(
                          columnName: 'Invoice', fontSize: fontSize),
                      StaffListColumn(columnName: 'Date', fontSize: fontSize),
                      StaffListColumn(columnName: 'Total', fontSize: fontSize),
                      StaffListColumn(columnName: 'Paid', fontSize: fontSize),
                      StaffListColumn(columnName: 'Due', fontSize: fontSize)
                    ]),
                TableRow(children: [
                  StaffListColumn(columnName: invoice),
                  StaffListColumn(columnName: date),
                  StaffListColumn(
                    columnName: total,
                    color: greenColor,
                  ),
                  StaffListColumn(
                    columnName: paid,
                    color: Colors.orangeAccent,
                  ),
                  StaffListColumn(
                    columnName: due,
                    color: Colors.redAccent,
                  ),
                ]),
              ]),
            ],
          ),
        ));
  }
}
