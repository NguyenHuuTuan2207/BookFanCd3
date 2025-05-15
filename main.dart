import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bookfan/consttants.dart';
import 'package:bookfan/screens/login_screen.dart';
import 'package:bookfan/screens/register_screen.dart';
import 'package:bookfan/widgets/rounded_button.dart';
import 'package:bookfan/widgets/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en'); // Default locale set to English

  // Function to change locale dynamically
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book App',
      locale: _locale,
      supportedLocales: [
        Locale('en'), // English
        Locale('vi'), // Vietnamese
      ],
      localizationsDelegates: [
        AppLocalizations.delegate, // Custom localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: kBlackColor,
            ),
      ),
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: WelcomeScreen(setLocale: setLocale), // Pass the setLocale function
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final Function(Locale) setLocale; // Callback to change locale

  WelcomeScreen({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseFontSize = screenWidth * 0.08; // Base font size that scales
    double basePadding = screenHeight * 0.05; // Base padding that scales

    final localizations = AppLocalizations.of(context)!; // Load localization

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bitmap.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: baseFontSize, // Responsive font size
                          color: kBlackColor,
                        ),
                    children: [
                      TextSpan(
                        text: "Book",
                      ),
                      TextSpan(
                        text: ".Fan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: baseFontSize, // Match responsive size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: basePadding), // Responsive spacing
            Column(
              children: [
                // Login Button
                SizedBox(
                  width: screenWidth * 0.6, // Responsive button width
                  child: RoundedButton(
                    text: localizations.translate("Login"), // Localized text
                    fontSize: screenWidth * 0.05, // Responsive button text size
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen(); // Navigate to LoginScreen
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10), // Reduced space between buttons
                // Register Button
                SizedBox(
                  width: screenWidth * 0.6, // Responsive button width
                  child: RoundedButton(
                    text: localizations.translate("Register"), // Localized text
                    fontSize: screenWidth * 0.05, // Responsive button text size
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterScreen(); // Navigate to RegisterScreen
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Language Toggle Button
              ],
            ),
          ],
        ),
      ),
    );
  }
}
