import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsis_app/design_screen.dart';
import 'package:dsis_app/sign_up_screen.dart';
import 'package:dsis_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool _isLoading = false;

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
    return Stack(children: [
      Scaffold(
        body: Center(
          child: SingleChildScrollView(
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          validator: (input) =>
                          input!.isEmpty ? 'Please enter your email' : null,
                          onSaved: (input) => email = input!,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
                        TextFormField(
                          validator: (input) =>
                          input!.isEmpty
                              ? 'Please enter your password'
                              : null,
                          onSaved: (input) => password = input!,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Theme
                          .of(context)
                          .colorScheme
                          .primaryContainer,
                      fixedSize: const Size(200, 60),
                    ),
                    onPressed: () {
                      signIn();
                    },
                    child: const Text('Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Theme
                          .of(context)
                          .colorScheme
                          .secondaryContainer,
                      fixedSize: const Size(200, 30)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'Activate My Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, "/design", arguments: {});
                    }, 
                    child: Text('design')),
              ],
            ),
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
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .primaryContainer,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondaryContainer,
              strokeWidth: 6,
            ),
          ),
        ),
    ]);
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        User? user = userCredential.user;
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Sign in successful'),
              backgroundColor: Color(0xFFa6e3a1),
              elevation: 10,
              width: 240,
            ),
          );
        });
        Navigator.pushReplacementNamed(
            context, "/home", arguments: {'user': user});
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('User not found. Please sign up first!'),
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .error,
              elevation: 10,
              width: 240,
            ),
          );
        });
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not found. Please sign up first!'),
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .error,
              elevation: 120,
            ),
          );
        } else if (e.code == 'wrong-password') {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Wrong Password'),
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .error,
              elevation: 10,
              width: 240,
            ),
          );
        }
      }
    }
  }
}
