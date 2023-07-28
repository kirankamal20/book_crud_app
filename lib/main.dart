import 'package:flutter/material.dart';
import 'package:loginapp/login/presentation/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            color: Colors.redAccent,
            iconTheme: IconThemeData(color: Colors.white)),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(15),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
