import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.pinkAccent,
          onPrimary: Colors.white, 
          secondary: Colors.pink, 
          onSecondary: Colors.white, 
          error: Colors.redAccent, 
          onError: Colors.white, 
          background: Color.fromRGBO(33, 33, 33, 1), 
          onBackground: Colors.pinkAccent, 
          surface: Color.fromARGB(87, 233, 30, 98), 
          onSurface: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}