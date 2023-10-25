import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/WelcomeScreen/welcome_screen.dart';
import 'package:olx_app/utils/my_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(Duration(seconds: 5), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      }
    });
  }

  double paddingVal = 50;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      paddingVal = 5;
      setState(() {});
    });
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(

            // color: MyColors.swanWhite
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedPadding(
                padding: EdgeInsets.all(paddingVal),
                duration: Duration(seconds: 1),
                child: Image.asset(
                  "Assets/images/logo.png",
                  width: 300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "sell, Parchase or exchange your old home Appliances",
                  style: TextStyle(
                      color: MyColors.luckyPoint,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Varela'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
