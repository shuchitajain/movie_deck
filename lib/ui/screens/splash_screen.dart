import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_deck/ui/config.dart';
import 'package:movie_deck/ui/screens/home_screen.dart';
import 'package:movie_deck/ui/screens/onboarding_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  final User? currentUser;

  const SplashScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final currUser;

  Future setUser() async {
    if (widget.currentUser == null) {
      if (await App.fss.read(key: "email") != null) {
        setState(() {
          currUser = App.fss.read(key: "email");
        });
      } else {
        setState(() {
          currUser = widget.currentUser!.email;
        });
      }
    }
    return currUser;
  }

  displaySplash() async {
    await setUser().whenComplete(() {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          PageTransition(
            child: currUser == null ? OnboardingScreen() : HomeScreen(),
            type: PageTransitionType.rightToLeft,
          ),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Image.asset(
            'assets/splash.gif',
          ),
        ),
      ),
    );
  }
}
