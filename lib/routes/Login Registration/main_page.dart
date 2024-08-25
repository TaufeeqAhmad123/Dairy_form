import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Login%20Registration/Login.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';
import 'package:khan_dairy/routes/Login%20Registration/verify_email.dart';

class MainPage extends StatelessWidget {
  static String id = 'MainPage';

  Future<void> userData() async {
    final firestore = FirebaseFirestore.instance.collection('Users');
    final auth = FirebaseAuth.instance;
    await firestore.where('Email', isEqualTo: auth.currentUser?.email).get()
        .then((QuerySnapshot value) {
      value.docs.forEach((doc) {
        print('${doc['Name']}');
        Registration.userName = doc['Name'];
        print("${doc['Phone']}");
        Registration.phone = doc['Phone'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final User? user = snapshot.data;
          if (user != null && !user.emailVerified) {
            print('Verify Email');
            return VarifyEmailScreen();
          } else {
            print('Dashboard');
            userData();
            return Dashboard();
          }
        } else {
          print('Login');
          return Login();
        }
      },
    );
  }
}
