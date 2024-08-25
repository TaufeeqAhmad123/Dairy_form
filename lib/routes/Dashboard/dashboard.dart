import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/modals/DashboardDrawer.dart' as drawer;
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';
import 'package:khan_dairy/routes/Settings/user_settings.dart';

class Dashboard extends StatefulWidget {
  static String id = "Dashboard";
  static String? farmName;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser?.email;

  double totalCollectedMilk = 0;
  double totalSoldMilk = 0;
  double totalExpense = 0;
  double totalRevenue = 0;
  int totalStaff = 0;
  int totalCows = 0;
  int totalStalls = 0;
  int totalSuppliers = 0;
  int totalCalves = 0;
  int totalPregnantCows = 0;

  @override
  void initState() {
    super.initState();
    addedBy();
    setDrawerName();
  }

  addedBy() async {
    print('Clicked');
    try {
      DocumentReference documentReference = firestore.collection('Users').doc(auth);
      await documentReference.get().then((snapshot) {
        Dashboard.farmName = snapshot.get('Farm Name');
        print("Farm Name ${Dashboard.farmName}");
        print("Current User ${auth}");
      });
    } catch (e) {
      print('Error fetching farm name: $e');
    }
  }

  void setDrawerName() async {
    final firestore = FirebaseFirestore.instance.collection('Users');
    final auth = FirebaseAuth.instance;

    try {
      await firestore.where('Email', isEqualTo: auth.currentUser?.email).get().then((QuerySnapshot value) {
        value.docs.forEach((doc) {
          Registration.userName = doc['Name'];
          Registration.phone = doc['Phone'];
          Registration.farmName = doc['Farm Name'];
          Registration.email = doc['Email'];
          Registration.password = doc['Password'];
        });
      });
    } catch (e) {
      print('Error setting drawer name: $e');
    }
  }

  Stream<Map<String, dynamic>> getDashboardData() async* {
    while (true) {
      Map<String, dynamic> data = {};
      try {
        // Total Milk Collection
        double totalCollectedMilk = 0;
        double totalSoldMilk = 0;
        double totalExpense = 0;
        double totalRevenue = 0;
        int totalStaff = 0;
        int totalCows = 0;
        int totalStalls = 0;
        int totalSuppliers = 0;
        int totalCalves = 0;
        int totalPregnantCows = 0;

        // Milk Collection
        await firestore.collection('Milk Collection')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            totalCollectedMilk += double.parse(doc['Milk LTR']);
          });
        });

        // Milk Sold
        await firestore.collection('Milk Sale')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            totalSoldMilk += double.parse(doc['Milk LTR']);
          });
        });

        // Expense
        await firestore.collection('Expense List')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            totalExpense += double.parse(doc['Amount']);
          });
        });

        // Revenue
        await firestore.collection('Milk Sale')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            totalRevenue += double.parse(doc['Total']);
          });
        });

        // Staff
        totalStaff = await firestore.collection('Staff List')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.length);

        // Cows
        totalCows = await firestore.collection('Cows List')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.length);

        // Stalls
        totalStalls = await firestore.collection('Stalls List')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.length);

        // Suppliers
        totalSuppliers = await firestore.collection('Suppliers List')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.length);

        // Calves
        totalCalves = await firestore.collection('Calves List')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.length);

        // Pregnant Cows
        totalPregnantCows = await firestore.collection('Animal Pregnancy')
            .where('Farm Name', isEqualTo: Dashboard.farmName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.length);

        data = {
          'totalCollectedMilk': totalCollectedMilk,
          'totalSoldMilk': totalSoldMilk,
          'totalExpense': totalExpense,
          'totalRevenue': totalRevenue,
          'totalStaff': totalStaff,
          'totalCows': totalCows,
          'totalStalls': totalStalls,
          'totalSuppliers': totalSuppliers,
          'totalCalves': totalCalves,
          'totalPregnantCows': totalPregnantCows,
        };
      } catch (e) {
        print('Error fetching dashboard data: $e');
      }
      yield data;
      await Future.delayed(Duration(seconds: 5));  // Refresh every 10 seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer.DashboardDrawer(),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: Text(
          'DFAS',
          style: TextStyle(fontSize: 25.0),
        ),
        elevation: 7.0,
        toolbarHeight: 70.0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, UserSettings.id);
            },
            child: Icon(
              Icons.settings,
              size: 30.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: StreamBuilder<Map<String, dynamic>>(
          stream: getDashboardData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data!;
            totalCollectedMilk = data['totalCollectedMilk'];
            totalSoldMilk = data['totalSoldMilk'];
            totalExpense = data['totalExpense'];
            totalRevenue = data['totalRevenue'];
            totalStaff = data['totalStaff'];
            totalCows = data['totalCows'];
            totalStalls = data['totalStalls'];
            totalSuppliers = data['totalSuppliers'];
            totalCalves = data['totalCalves'];
            totalPregnantCows = data['totalPregnantCows'];

            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InteractiveViewer(
                          child: MyCard(
                            name: 'Collected Milk',
                            quantity: '${totalCollectedMilk}-Ltr',
                            image: Image.asset(
                              'images/cowIcon.png',
                              scale: 1.2,
                            ),
                            color: Color(0xFFFD6769),
                          ),
                        ),
                        MyCard(
                          name: 'Sold Milk',
                          quantity: '${totalSoldMilk}-ltr',
                          image: Image.asset(
                            'images/soldmilkIcon.png',
                            scale: 2.1,
                          ),
                          color: Color(0xFF119DA4),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyCard(
                          name: 'Expense',
                          quantity: 'Rs.${totalExpense}',
                          image: Image.asset(
                            'images/expenseIcon.png',
                            scale: 4.1,
                            color: Colors.pink,
                          ),
                          color: Colors.pink,
                        ),
                        MyCard(
                          name: 'Revenue',
                          quantity: '${totalRevenue}',
                          image: Image.asset(
                            'images/revenueIcon.png',
                            scale: 1.7,
                          ),
                          color: Color(0xFF48294C),
                        ),
                      ],
                    ),
                    SizedBox(height: 13.0),
                    Container(
                      child: Table(
                        border: TableBorder.symmetric(inside: BorderSide(width: 0.1)),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                              color: Colors.white,
                            ),
                            children: [
                              TableCard(text: 'Staff', quantity: '$totalStaff'),
                              TableCard(text: 'Cows', quantity: '$totalCows'),
                              TableCard(text: 'Stalls', quantity: '$totalStalls'),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0)),
                              color: Colors.white,
                            ),
                            children: [
                              TableCard(text: 'Suppliers', quantity: '$totalSuppliers'),
                              TableCard(text: 'Calves', quantity: '$totalCalves'),
                              TableCard(text: 'Pregnant ', quantity: '${totalPregnantCows}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
