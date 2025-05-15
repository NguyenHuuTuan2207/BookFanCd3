import 'package:bookfan/widgets/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookfan/screens/login_screen.dart'; // Import the login screen

class UserScreen extends StatelessWidget {
  final Function(Locale) setLocale;
  final String userName;

  UserScreen({required this.setLocale, required this.userName});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/profile_picture.png'), // Replace with actual image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName, // Dynamically display the username
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          // Account, Preferences, Settings
          ListTile(
            leading: Icon(Icons.person),
            title: Text(localizations.translate('account')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Account tap
            },
          ),
          ListTile(
            leading: Icon(Icons.tune),
            title: Text(localizations.translate('preferences')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Preferences tap
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(localizations.translate('settings')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Settings tap
            },
          ),
          // Help and Logout
          ListTile(
            leading: Icon(Icons.help),
            title: Text(localizations.translate('help')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Help tap
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(localizations.translate('logout')),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Call the logout function when tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
