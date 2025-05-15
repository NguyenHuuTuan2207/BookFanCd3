import 'package:bookfan/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookfan/screens/home_screen.dart'; // Import HomeScreen
import 'package:bookfan/widgets/rounded_button.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'dart:convert'; // For JSON encoding/decoding

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to log in the user
  Future<void> loginUser(BuildContext context) async {
    final String apiUrl = "http://localhost:3000/login"; // Server endpoint

    try {
      // Prepare data to send
      Map<String, dynamic> requestBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      // Make POST request to server
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the JSON response
        final responseData = jsonDecode(response.body);

        // Print the decoded response for debugging
        print('Decoded response: $responseData');

        // Extract the correct field (username)
        final userName = responseData['username'] ??
            'User'; // Use 'username' here instead of 'name'

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful!")),
        );

        // Pass the correct username to the HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen(
                setLocale: (Locale locale) {},
                userName: userName, // Pass the correct username
              );
            },
          ),
        );
      } else {
        // Handle error response from server
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Error: ${errorData['message'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to server.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                "Login",
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
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
                text: "Login",
                fontSize: screenWidth * 0.05,
                press: () {
                  loginUser(context); // Call loginUser function
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  "Don't have an account? Register",
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
