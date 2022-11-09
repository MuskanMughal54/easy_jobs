import 'package:easy_jobs/constants.dart';
import 'package:easy_jobs/screens/screens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:easy_jobs/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterationScreen extends StatefulWidget {
  static const String idScreen = "register";

  const RegisterationScreen({Key? key}) : super(key: key);

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  var isLoading = false;

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff154c79),
      backgroundColor: kPrimaryLightColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/img1.png',
                    fit: BoxFit.cover,
                    height: 280,
                    width: 300,
                  ),
                ),
                const SizedBox(height: 0),
                const Text("Find Your Dream Job",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 24.0,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 15,
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameTextEditingController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            icon: const Icon(Icons.person, color: Colors.white, size: 30),
                            hintText: "Your Name",
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: " Brand-Regular "),
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 15,
                        width: 20,
                      ),
                      TextFormField(
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            icon: const Icon(Icons.email, color: Colors.white, size: 30),
                            hintText: "Enter Email",
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: " Brand-Regular "),
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 15,
                        width: 20,
                      ),
                      TextFormField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            icon: const Icon(Icons.phone, color: Colors.white, size: 30),
                            hintText: "Phone Number",
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: " Brand-Regular "),
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 15,
                        width: 20,
                      ),
                      TextFormField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            icon: const Icon(Icons.lock, color: Colors.white, size: 30),
                            hintText: "Your Password",
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: " Brand-Regular "),
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 15,
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // if any of the field is empty do not go ahead
                                var isValid = true;
                                if (nameTextEditingController.text.isEmpty) {
                                  addToast(context: context, message: 'Name can not be empty', type: 'error');
                                  isValid = false;
                                } else if (nameTextEditingController.text.length < 3) {
                                  addToast(context: context, message: 'Name should have at least 3 characters', type: 'error');
                                  isValid = false;
                                } else if (emailTextEditingController.text.isEmpty) {
                                  addToast(context: context, message: 'Email can not be empty', type: 'error');
                                  isValid = false;
                                } else if (!emailTextEditingController.text.contains('@')) {
                                  addToast(context: context, message: 'Email is not valid', type: 'error');
                                  isValid = false;
                                } else if (emailTextEditingController.text.length < 3) {
                                  addToast(context: context, message: 'Email should have at least 3 characters', type: 'error');
                                  isValid = false;
                                } else if (phoneTextEditingController.text.isEmpty) {
                                  addToast(context: context, message: 'Phone can not be empty', type: 'error');
                                  isValid = false;
                                } else if (phoneTextEditingController.text.length < 11) {
                                  addToast(context: context, message: 'Phone shoud be 11 characters long');
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
                                  _auth
                                      .createUserWithEmailAndPassword(
                                    email: emailTextEditingController.text,
                                    password: passwordTextEditingController.text,
                                  )
                                      .then((userCredentail) {
                                    _firestore.collection('users').doc(userCredentail.user?.uid).set({
                                      "name": nameTextEditingController.text,
                                      "email": emailTextEditingController.text,
                                      "phone": phoneTextEditingController.text,
                                    }).then((data) {
                                      addToast(
                                        context: context,
                                        message: 'User registered Successfully',
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: ((context) => const HomeScreen())));
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
                            child: Text("Submit", style: TextStyle(color: Colors.black, fontFamily: " Brand-Regular ")),
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
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: const Text(
                      "Already have an account? Sign in",
                      style: TextStyle(color: Colors.white, fontFamily: "Brand-Regular"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
