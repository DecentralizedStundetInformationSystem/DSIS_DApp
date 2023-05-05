import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
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
              controller: emailcontroller,
              decoration: const InputDecoration (labelText: 'Email'),
              validator: (input) => input!.isEmpty ? 'Please enter your school email' : null,
            ),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration (labelText: 'ID'),
              validator: (input) => input!.isEmpty ? 'Please enter your school ID' : null,
            ),
            TextFormField(
              controller: passwordController,
              decoration:  const InputDecoration(labelText: 'Password'),
              validator: (input) => input!.isEmpty ? 'Please enter a password' : null,
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                String email = emailcontroller.text;
                List<String> parts = email.split('@');
                String username = parts[0];
                List<String> nameParts = username.split('.');
                String name = nameParts.join(' ');
                var response = await http.post(
                  Uri.parse('https://dsisapp.cyclic.app/signup'),
                  body: {
                    'name': name,
                    'schoolId': idController.text,
                  },
                );

                if (response.statusCode == 200) {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailcontroller.text,
                      password: passwordController.text,
                    );

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
              }
            }, 
                child: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
