import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';

class VarifyEmailScreen extends StatelessWidget {
  static String id = 'VerifyEmailScreen';
  const VarifyEmailScreen({super.key});

  Future<void> checkEmailVerificationStatus(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Reload the user to get the latest data
    await currentUser?.reload();

    // Update the user data after reload
    final updatedUser = FirebaseAuth.instance.currentUser;

    if (updatedUser != null && updatedUser.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } else {
      // If email is still not verified, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email is not verified yet. Please check again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Image(image: AssetImage('images/email.png')),
                SizedBox(height: 15),
                Text(
                  'Verify your email address!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Congratulations! Your Account Awaits: Verify Your Email to Start!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      checkEmailVerificationStatus(context);
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
