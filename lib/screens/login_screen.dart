import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // A beautiful gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // To avoid overflow issues with the keyboard
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Restaurant Icon
                Icon(Icons.restaurant_menu, color: Colors.white, size: 80),
                SizedBox(height: 20),
                // Welcome Title
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                // Email Field
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.deepOrange),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.deepOrange),
                  ),
                ),
                SizedBox(height: 20),
                // Password Field
                TextField(
                  obscureText: true, // To hide the password
                  style: TextStyle(color: Colors.deepOrange),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                  ),
                ),
                SizedBox(height: 30),
                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepOrange,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // On press, navigate to the home screen and replace this screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text('Login', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),
                // Link to create a new account
                TextButton(
                  onPressed: () {
                    // Navigate to the signup screen
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
