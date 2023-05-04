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

  late String studentNo, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (input)  => input!.isEmpty ? 'Please enter your email' : null,
                onSaved: (input) => studentNo = input!,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                validator: (input) => input!.isEmpty ? 'Please enter your password' : null,
                onSaved: (input) => password = input!,
                obscureText: true,
                decoration: const InputDecoration(    
                    labelText: 'PAssword'
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Sign In'),
                onPressed: () {
                  signIn();
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text('Don\'t have an account? Sign up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentNo)
            .get();
        if (!studentDoc.exists) {
          Fluttertoast.showToast( 
            msg: 'User not found. Please sign up first!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        final studentData = studentDoc.data()!;
        final studentEmail = studentData['email'] as String;

        UserCredential userCredential = await auth.signInWithEmailAndPassword(email: studentEmail, password: password);
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
      } on FirebaseAuthException catch (e) {
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



