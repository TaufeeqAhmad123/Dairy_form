import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:khan_dairy/constants/validator.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Login%20Registration/forgot_password.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';

class Login extends StatefulWidget {
  static String id = 'Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Firebase Instance
  FirebaseAuth auth = FirebaseAuth.instance;

  //Defining Controllers
  TextEditingController emailController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Logging In.
  void loginChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  bool isLoading = false;

  Future<bool> login({required BuildContext context}) async {
    try {
     setState(() {
        isLoading = true;
     });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Succeessfully Logged In"),
      ));
      setState(() {
        isLoading = false;
      });
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user found for that email.'),
        ));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong password provided for that user.'),
        ));
      }else if (e.code == 'email-already-in-use') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong password provided for that user.'),
        ));
      }
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email not found.please register email first"),
      ));
      setState(() {
         isLoading = false;
  
      });
    }catch(e){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e}'),
      ));
      

    }
    return false;
  }

  checkLogin() {
    auth.authStateChanges();
  }

  //This Won't Be Necessary As Method Is Already Working From Dashboard/Registration.
  void userData() async {
    final firestore = FirebaseFirestore.instance.collection('Users');
    final auth = FirebaseAuth.instance;
    await firestore
        .where('Added By', isEqualTo: auth.currentUser?.email)
        .get()
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
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
                  height: 20,
                ),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                            controller: emailController,
                            hintText: "Email",
                            prefix: Icon(Icons.email),
                            keyboardType: TextInputType.emailAddress,
                           validator: (value)=>Validator.validateEmail(value),),
                        CustomTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                          prefix: Icon(Icons.password_outlined),
                          validator: (value)=>Validator.validatePassword(value),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ForgotPasswordScreen.id);
                                },
                                child: Text("Forgot Password?"))
                          ],
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 50,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                          buttonName: "Login",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              if (await login(context: context)) {
                                userData();
                                Navigator.pushNamed(context, Dashboard.id);
                              }
                              isLoading = true;
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Registration.id);
                    },
                    child: Text("Register"))
              ],
            ),
          ),
        ));
  }

 
}
