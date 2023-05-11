import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsis_app/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 90,
            ),
            Image.asset(
              'assets/images/info.png',
              height: 40,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      validator: (input) => input!.isEmpty
                          ? 'Please enter your email'
                          : null,
                      onSaved: (input) => email = input!,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0, 
                            vertical: 6)
                    ),
                    TextFormField(
                      validator: (input) => input!.isEmpty
                          ? 'Please enter your password'
                          : null,
                      onSaved: (input) => password = input!,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  fixedSize: const Size(200, 60),
              ),
              onPressed: () {
                signIn();
              },
              child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
              )
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                fixedSize: const Size(200, 30)
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text('Activate My Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
        try {
          UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
          User? user = userCredential.user;
          Fluttertoast.showToast(
            msg: 'Sign in successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );
          Navigator.pushReplacementNamed(context, "/home", arguments: {'user': user });
        }
        on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: 'User not found. Please sign up first!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: 'Wrong password. Please try again',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }
    }
  }
}



