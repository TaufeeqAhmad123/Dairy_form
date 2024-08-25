import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';
import '../Dashboard/dashboard.dart';

class VaccineMonitorReport extends StatefulWidget {
  static String id = 'VaccineMonitorReport';

  @override
  State<VaccineMonitorReport> createState() => _VaccineMonitorReportState();
}

class _VaccineMonitorReportState extends State<VaccineMonitorReport> {

  //Controllers
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();

  final firestore = FirebaseFirestore.instance;

  List<TableRow> dates = [];

  checkDate() async {


    await firestore
        .collection('Vaccine Information')
        .where('Date',
        isGreaterThanOrEqualTo: '${fromDate.text}'.toLowerCase(),
        isLessThanOrEqualTo: '${toDate.text}'.toLowerCase())
        .get()
        .then((QuerySnapshot value)async {

      await firestore.collection('Vaccine Information')
          .where('Farm Name',isEqualTo: Dashboard.farmName).get()
          .then((QuerySnapshot value) {
        dates.add(TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            children: [
              StaffListColumn(columnName: 'Date',fontSize: fontSize,),
              StaffListColumn(columnName: 'Stall No',fontSize: fontSize,),
              StaffListColumn(columnName: 'Animal Id',fontSize: fontSize,),
              StaffListColumn(columnName: 'Vaccine Name',fontSize: fontSize,),
            ]

        ));
        value.docs.forEach((doc) {

          dates.add(
            TableRow(
              children: [
                StaffListColumn(columnName: '${doc['Date']}'),
                StaffListColumn(columnName: '${doc['Stall No']}'),
                StaffListColumn(columnName: '${doc['Animal Id']}'),
                StaffListColumn(columnName: '${doc['Vaccine Name']}'),
              ],
            ),
          );
        });
      });
      });

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
        title: const Text('Vaccine Report'),
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
                  'Vaccine Report\nFrom: ${fromDate.text}\nTo: ${toDate.text}'),

              CustomTableRowDesign(children: dates),
            ],
          ),
        ),
      ),
    );
  }
}
