import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../modals/global_widgets.dart';

class StaffList extends StatefulWidget {
  static String id = 'StaffList';

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        centerTitle: true,
        title: const Text('Staff List'),
      ),
      body: SingleChildScrollView(
        child: ShowList(userList: false,),
      ),

    );
  }
}