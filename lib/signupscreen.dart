import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'loginscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (input) =>
                  input!.isEmpty ? 'Please enter your school email' : null,
            ),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'ID'),
              validator: (input) =>
                  input!.isEmpty ? 'Please enter your school ID' : null,
            ),
            TextFormField(
              controller: facultyController,
              decoration: const InputDecoration(labelText: 'Faculty'),
              validator: (input) =>
                  input!.isEmpty ? 'Please enter your faculty' : null,
            ),
            TextFormField(
              controller: departmentController,
              decoration: const InputDecoration(labelText: 'Department'),
              validator: (input) =>
                  input!.isEmpty ? 'Please enter your department' : null,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await signUp(context);
                 showPasswordDialog(context);
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> signUp(BuildContext context) async {
     if (formKey.currentState!.validate()) {
      String email = emailController.text;
      List<String> parts = email.split('@');
      String username = parts[0];
      List<String> nameParts = username.split('.');
      String name = nameParts.join(' ');
      DateTime now = DateTime.now();
      int currentYear = now.year;
      var response = await http.post(
        Uri.parse('https://dsisapp.cyclic.app/signup'),
        body: {
          'name': name,
          'schoolId': idController.text,
          'faculty': facultyController.text,
          'department': departmentController.text,
          'regYear': currentYear.toString()
        },
      );
      showPasswordDialog(context);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Enrollment successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFFa6e3a1),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                'Enrollment failed. ${response.statusCode} ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFFf38ba8),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
void showPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        
        title: const Text('Important Information'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actionsAlignment: MainAxisAlignment.center,
        content: const Text('Your initial password is your school number. '
            'You can change your password later when you log in.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      );
    },
  );
}


