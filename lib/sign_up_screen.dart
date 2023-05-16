import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'log_in_screen.dart';

bool _isLoading = false;

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Sign Up'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (input) =>
                        input!.isEmpty ? 'Please enter your school email' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'ID'),
                    validator: (input) =>
                        input!.isEmpty ? 'Please enter your school ID' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: facultyController,
                    decoration: const InputDecoration(labelText: 'Faculty'),
                    validator: (input) =>
                        input!.isEmpty ? 'Please enter your faculty' : null,
                  ),
                  const SizedBox(height: 20),
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
          ),
            if (_isLoading)
              const Opacity(
                opacity: 0.5,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            if (_isLoading)
              Center(
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    strokeWidth: 6,
                  ),
                ),
              ),
          ]
        ),
      ),
    );
  }

Future<void> signUp(BuildContext context) async {
     if (formKey.currentState!.validate()) {
       setState(() {
         _isLoading = true;
       });
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
       setState(() {
         _isLoading = false;
       });
      showPasswordDialog(context);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Enrollment Successful!'),
            backgroundColor: Color(0xFFa6e3a1),
            elevation: 10,
            width: 240,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Enrollment failed. ${response.statusCode} ${response.body}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            elevation: 10,
            width: 240,
          ),
        );
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


