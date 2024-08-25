import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

import '../../constants/constants.dart';
import '../Dashboard/dashboard.dart';

class CowSaleDue extends StatefulWidget {
  static String id = 'CowSaleDue';

  @override
  State<CowSaleDue> createState() => _CowSaleDueState();
}

class _CowSaleDueState extends State<CowSaleDue> {
  String? invoice = '';

  String? date = '';

  String? price = '';

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
          title: const Text('Cow Sale Due'),
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
                        .collection('Cow Sale')
                        .doc(val)
                        .get()
                        .then((snapshot) {
                      invoice = snapshot['Invoice'];
                      date = snapshot['Date'];
                      price = snapshot['Price'];
                      paid = snapshot['Paid'];
                      due = snapshot['Due'];
                      setState(() {});
                    });
                  },
                  onSuggestionCallback: (val) async {
                    List<String?> invoiceList = [];
                    await firestore
                        .collection('Cow Sale')
                        .where('Farm Name', isEqualTo: Dashboard.farmName)
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
                      StaffListColumn(columnName: 'Price', fontSize: fontSize),
                      StaffListColumn(columnName: 'Paid', fontSize: fontSize),
                      StaffListColumn(columnName: 'Due', fontSize: fontSize)
                    ]),
                TableRow(children: [
                  StaffListColumn(columnName: invoice),
                  StaffListColumn(columnName: date),
                  StaffListColumn(
                    columnName: price,
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
