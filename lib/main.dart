import 'dart:async';

import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _SplashScreen(),
      routes: {
        'LoginPage': (context) => LoginPage(),
      },
    );
  }
}

class _SplashScreen extends StatefulWidget {
  @override
  __SplashScreenState createState() => __SplashScreenState();
}

class __SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, 'LoginPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Image.asset(
        'assets/images/splash.png',
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
