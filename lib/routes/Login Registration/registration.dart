import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khan_dairy/constants/validator.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Login%20Registration/verify_email.dart';
import '../../constants/constants.dart';
import 'Login.dart';
import 'package:khan_dairy/modals/DashboardDrawer.dart';

class Registration extends StatefulWidget {
  static String userName = 'User';
  static String phone = '03****';
  static String? farmName;
  static String? password;
  static String? email;

  //Setting Drawer Name
  void setDrawerName() async {
    final firestore = FirebaseFirestore.instance.collection('Users');
    final auth = FirebaseAuth.instance;
    await firestore
        .where('Email', isEqualTo: auth.currentUser?.email)
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((doc) {
        print('${doc['Name']}');
        Registration.userName = doc['Name'];
        print("${doc['Phone']}");
        Registration.phone = doc['Phone'];
        print("${doc['Farm Name']}");
        Registration.farmName = doc['Farm Name'];
        print("${doc['Email']}");
        Registration.email = doc['Email'];
        print("${doc['Password']}");
        Registration.password = doc['Password'];
      });
    });
  }

  static String id = 'Registration';

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  //Firebase Auth.
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController nameController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();
  TextEditingController resetpasswordController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  //Registering With Email And Password.
  Future<bool> registerUser({required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      sendEmailvarification();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("User Succeessfully Registered In"),
      // ));
      setState(() {});
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
      ));
      setState(() {});
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      setState(() {});
      return false;
    }
  }

  Future<void> sendEmailvarification() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please check your inbox and verify your email"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error Occured$e"),
      ));
    }
  }

  addUserData() {
    final firestore = FirebaseFirestore.instance;
    print('Adding Data');
    firestore.collection('Users').doc(emailController.text).set({
      'Name': nameController.text.trim(),
      'Phone': phoneController.text.trim(),
      'Farm Name': emailController.text.trim(),
      'Email': emailController.text.trim(),
      'Password': passwordController.text.trim(),
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    widget.setDrawerName();
  }
  //Screen Starts Here

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Image.asset(
                  "images/appLogo.png",
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sign Up",
                  style: headlineTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(),
                //Name
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        hintText: "Name",
                        prefix: Icon(FontAwesomeIcons.user),
                      ),
                      //Phone
                      CustomTextField(
                        controller: phoneController,
                        hintText: "Phone",
                        prefix: Icon(Icons.phone),
                        validator: (value) =>
                            Validator.validatePhoneNumber(value),
                      ),
                      //Email
                      CustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        prefix: Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => Validator.validateEmail(value),
                      ),
                      //Password
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                        prefix: Icon(Icons.password_outlined),
                        validator: (value) => Validator.validatePassword(value),
                      ),
                      CustomTextField(
                        controller: resetpasswordController,
                        hintText: "confirm Password",
                        obscureText: true,
                        prefix: Icon(Icons.password_outlined),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            Validator.validatePassword(value);
                          }
                          if (passwordController.text !=
                              resetpasswordController.text) {
                            return 'Password does not match';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 50,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                          buttonName: "Register",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              if (await registerUser(
                                context: context,
                              )) {
                                print('object');
                                Navigator.pushNamed(context, VarifyEmailScreen.id);
                                addUserData();
                              //  widget.setDrawerName();
                              } else {
                                print('Error');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Login.id);
                    },
                    child: Text("Login"))
              ],
            ),
          ),
        ));
  }
}
