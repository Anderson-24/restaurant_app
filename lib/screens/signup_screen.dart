import 'package:flutter/material.dart';
import 'home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // *** التعديل هنا: استخدام نفس الخلفية البرتقالية ***
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // المحتوى الرئيسي
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create a New Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    // *** التعديل هنا: تغيير لون النص والأيقونة ***
                    style: TextStyle(color: Colors.deepOrange),
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.person, color: Colors.deepOrange),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    // *** التعديل هنا: تغيير لون النص والأيقونة ***
                    style: TextStyle(color: Colors.deepOrange),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.deepOrange),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    // *** التعديل هنا: تغيير لون النص والأيقونة ***
                    style: TextStyle(color: Colors.deepOrange),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // *** التعديل هنا: تغيير لون النص ليتناسب ***
                      foregroundColor: Colors.deepOrange,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text('Sign Up', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
          // زر الرجوع للخلف في الأعلى
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
