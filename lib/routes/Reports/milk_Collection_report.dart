import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class MilkCollectionReport extends StatefulWidget {
  static String id = 'MilkCollectionReport';

  @override
  State<MilkCollectionReport> createState() => _MilkCollectionReportState();
}

class _MilkCollectionReportState extends State<MilkCollectionReport> {

  //Controllers
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();

  final firestore = FirebaseFirestore.instance;

  List<TableRow> dates = [];

  double totalExpense = 0;
  checkDate() async {

    List<double> expenseAmount = [];

    await firestore
        .collection('Milk Collection')
        .where('Date',
        isGreaterThanOrEqualTo: '${fromDate.text}'.toLowerCase(),
        isLessThanOrEqualTo: '${toDate.text}'.toLowerCase())
        .get()
        .then((QuerySnapshot value) async{

      await firestore.collection('Milk Collection')
          .where('Farm Name',isEqualTo: Dashboard.farmName).get()
          .then((QuerySnapshot value) {
        dates.add(TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            children: [
              StaffListColumn(columnName: 'Date',fontSize: fontSize,),
              StaffListColumn(columnName: 'Milk LTR',fontSize: fontSize,),
              StaffListColumn(columnName: 'Total Price',fontSize: fontSize,),
            ]

        ));
        value.docs.forEach((doc) {

          expenseAmount.add(double.parse(doc['Total']));
          dates.add(
            TableRow(
              children: [
                StaffListColumn(columnName: '${doc['Date']}'),
                StaffListColumn(columnName: '${doc['Milk LTR']}'),
                StaffListColumn(columnName: '${doc['Total']}'),
              ],
            ),
          );
        });
      });
      });



    totalExpense = expenseAmount.reduce((value, element) => value + element);
    setState(() {});
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Milk Collection Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              dateSelectionTextField(
                hintText: 'Select From Date',
                calendarDate: fromDate,
              ),
              dateSelectionTextField(
                hintText: 'Select To Date',
                calendarDate: toDate,
              ),
              CustomButton(
                icon: FontAwesomeIcons.magnifyingGlass,
                buttonName: 'Search',
                onPressed: () {
                  checkDate();
                  dates.clear();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Your data is being fetched, Please wait...')));
                },
              ),
              InformationText(
                  'Milk Collection Report\nFrom: ${fromDate.text}\nTo: ${toDate.text}'),

              CustomTableRowDesign(children: dates),
              TotalReportInfo('Total: $totalExpense'),
            ],
          ),
        ),
      ),
    );
  }
}
