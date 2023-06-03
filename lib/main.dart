import 'package:dsis_app/sign_up_screen.dart';
import 'package:dsis_app/transcript_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dsis_app/log_in_screen.dart';
import 'package:dsis_app/home_screen.dart';
import 'package:dsis_app/semester_grades.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/semester': (context) => const SemesterGrades(),
        '/transcript': (context) => const TranscriptScreen(),
      },
      theme: ThemeData(
          fontFamily: 'iAWriterDuoS',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 13),
            bodySmall: TextStyle(fontSize: 12),
          ),
          scaffoldBackgroundColor: const Color(0xFF11111b),
          colorScheme: const ColorScheme.dark(
              primary: Color(0xFF74c7ec),
              secondary: Color(0xFF94e2d5),
              surface: Color(0xFF181825),
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
              outline: Color(0xFFef9f76)),
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusColor: Theme.of(context).colorScheme.primary,
              floatingLabelAlignment: FloatingLabelAlignment.center),
          buttonTheme: ButtonThemeData(
            colorScheme: Theme.of(context).colorScheme,
            height: 30,
            minWidth: 200,
          ),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size(200, 30)),
          ))),
    );
  }
}
