import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // We will create this file shortly

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
