import 'package:easy_jobs/constants.dart';
import 'package:easy_jobs/screens/home_screen.dart';
import 'package:easy_jobs/screens/registerationScreen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 45.0),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/img1.png',
                  //fit: BoxFit.cover,
                  height: 240,
                  width: 300,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Welcome to Easy Jobs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Brand Bold", fontSize: 24.0,
                    color: Colors.white,
                    //textAlign: TextAlign.center
                  )),
              const SizedBox(
                height: 20,
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          icon: const Icon(Icons.person, color: Colors.white, size: 30),
                          hintText: "Enter Email",
                          hintStyle: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: " Brand-Regular "),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          icon: const Icon(Icons.email, color: Colors.white, size: 30),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: " Brand-Regular "),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              var isValid = true;
                              if (!emailTextEditingController.text.contains('@')) {
                                addToast(context: context, message: 'Email is not valid', type: 'error');
                                isValid = false;
                              } else if (emailTextEditingController.text.length < 3) {
                                addToast(context: context, message: 'Email should have at least 3 characters', type: 'error');
                                isValid = false;
                              } else if (passwordTextEditingController.text.isEmpty) {
                                addToast(context: context, message: 'Password can not be empty', type: 'error');
                                isValid = false;
                              } else if (passwordTextEditingController.text.length < 8) {
                                addToast(context: context, message: 'Password should have at least 8 characters', type: 'error');
                                isValid = false;
                              }
                              if (isValid) {
                                setState(() {
                                  isLoading = true;
                                });
                                _auth.signInWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                                }).onError((FirebaseAuthException err, trace) {
                                  addToast(context: context, message: err.message.toString(), type: 'error');
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }
                            },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(9999)))),
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) return Colors.grey[300];
                          return Colors.white;
                        }),
                        foregroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) return Colors.grey[800];
                          return Colors.black;
                        }),
                      ),
                      child: Container(
                        width: 150,
                        height: 35,
                        child: const Center(
                          child: Text("Login", style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterationScreen(),
                        ));
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white, fontFamily: "Brand-Regular"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
