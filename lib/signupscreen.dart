import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration (labelText: 'Email'),
              validator: (input) => input!.isEmpty ? 'Please enter your email' : null,
            ),
            TextFormField(
              controller: passwordController,
              decoration:  const InputDecoration(labelText: 'Password'),
              validator: (input) => input!.isEmpty ? 'Please enter a password' : null,
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  String uid = userCredential.user!.uid;
                  await FirebaseFirestore.instance.collection('students').doc(uid).set({
                    'email': emailController.text,
                  });
                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    Fluttertoast.showToast(
                        msg: 'The password is weak!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  } else if (e.code == 'email-already-in-use') {
                    Fluttertoast.showToast(
                        msg: 'This email is already in use!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                } catch (e) {
                  print(e);
                }
              }
            },
                child: Text('Sign up'))
          ],
        ),
      ),
    );
  }
}
