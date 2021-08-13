import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/ui/widgets/app_logo_widget.dart';
import 'package:movie_deck/ui/widgets/bezier_container_widget.dart';
import 'package:page_transition/page_transition.dart';
import '../config.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Widget _registerButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SignupScreen(),
          ),
        );
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: kGreyColor.withAlpha(100),
              offset: Offset(2, 4),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
          color: kPrimaryColor,
        ),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 20,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }

  Widget _exploreButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: HomeScreen(),
          ),
        );
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: kPrimaryColor, width: 2),
        ),
        child: Text(
          'Explore',
          style: TextStyle(
            fontSize: 20,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: App.height(context),
          child: Stack(
            children: [
              Positioned(
                top: -App.height(context) * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Positioned(
                left: 0,
                top: App.height(context) * .15,
                child: appLogoWidget(context),
              ),
              Container(
                margin: EdgeInsets.only(top: App.height(context) * .2),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "One stop destination for your movie watchlist",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    _registerButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _exploreButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
