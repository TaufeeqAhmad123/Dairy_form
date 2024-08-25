import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/constants/validator.dart';
import 'package:khan_dairy/modals/global_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'ResetPassword';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController ForgotpasswordController = new TextEditingController();
  final _formkey=GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> ResetPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      await auth.sendPasswordResetEmail(email: ForgotpasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Reset email send .')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.message ?? 'Failed to send password reset email.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Reset Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomTextField(
                  controller: ForgotpasswordController,
                  hintText: "Email",
                  prefix: Icon(Icons.email),
                  validator: (value)=>Validator.validateEmail(value),
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                      buttonName: "Send Email",
                      onPressed: () {
                       if(_formkey.currentState!.validate()){
                         ResetPassword();
                         setState(() {
                           
                         });
                       }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
