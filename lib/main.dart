import 'package:dsis_app/signupscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dsis_app/loginscreen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
          body: Column(
            children:[ ElevatedButton(onPressed: () { 
              showPasswordDialog(context);}, child: Text('')
            ),
    ]
          ),
        ),
        '/signup': (context) => const SignUpScreen(),
      },
      theme: ThemeData(
        fontFamily: 'iAWriterDuoS',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
        ),
        scaffoldBackgroundColor: const Color(0xFF1e1e2e),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF74c7ec),
          secondary: Color(0xFF94e2d5),
          surface: Color(0xFF313244),
          onBackground: Color(0xFFCDD6F4),
          onError: Color(0xFFCDD6F4),
          onPrimary: Color(0xFF313244),
          onSecondary: Color(0xFF313244),
          onSurface: Color(0xFFCDD6F4),
          brightness: Brightness.dark,
          error: Color(0xFFf38ba8),
          errorContainer: Color(0xFFf38ba8),
          onErrorContainer: Color(0xFF313244),
          primaryContainer: Color(0xFFb4befe),
          onPrimaryContainer: Color(0xFF181825),
          secondaryContainer: Color(0xFF89b4fa),
          onSecondaryContainer: Color(0xFF181825),
        ),
      ),
    );
  }
}