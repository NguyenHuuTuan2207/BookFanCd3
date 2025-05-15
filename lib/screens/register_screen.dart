import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import
import 'dart:convert'; // For JSON encoding/decoding
import 'package:bookfan/consttants.dart'; // Make sure you have constants defined
import 'package:bookfan/widgets/rounded_button.dart'; // Assuming you have a custom button widget

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Function to register a new user
    Future<void> registerUser(BuildContext context) async {
      final String apiUrl =
          "http://localhost:3000/register"; // Your server endpoint

      try {
        // Prepare data to send
        Map<String, dynamic> requestBody = {
          "username": usernameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        };

        // Make POST request to server
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          // Registration successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration successful!")),
          );
          Navigator.pop(context); // Navigate back to login screen
        } else {
          // Error occurred
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to connect to server.")),
        );
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.1),
              Text(
                "Register",
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              RoundedButton(
                text: "Register",
                fontSize: screenWidth * 0.05,
                press: () {
                  registerUser(context); // Call registerUser function
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to LoginScreen
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
