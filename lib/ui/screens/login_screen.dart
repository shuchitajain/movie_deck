import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/repository/user_repository.dart';
import 'package:movie_deck/ui/screens/home_screen.dart';
import 'package:movie_deck/ui/screens/signup_screen.dart';
import 'package:movie_deck/ui/widgets/app_logo_widget.dart';
import 'package:movie_deck/ui/widgets/back_button_widget.dart';
import 'package:movie_deck/ui/widgets/bezier_container_widget.dart';
import 'package:movie_deck/ui/widgets/reusable_button_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPassword = true;

  void _toggle() {
    setState(() {
      _isPassword = !_isPassword;
    });
  }

  Widget _entryField(
      {required String title,
      required IconData icon,
      required TextEditingController controller,
      obscure,
      isPassword,
      FormFieldValidator? validate}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            key: Key(title),
            obscureText: obscure,
            controller: controller,
            validator: validate,
            keyboardType:
                !isPassword ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: !isPassword ? "example@gmail.com" : "******",
              prefixIcon: Icon(
                icon,
              ),
              suffix: isPassword
                  ? InkWell(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: kBlackColor,
                        size: 20,
                      ),
                      onTap: () {
                        _toggle();
                      },
                    )
                  : null,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccount() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignupScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(
            text: 'Don\'t have an account ?  ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: kBlackColor),
            children: [
              TextSpan(
                text: 'Register',
                style: TextStyle(
                    color: Color(0xfff79c4f),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -App.height(context) * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Positioned(
                left: 0,
                top: App.height(context) * .15,
                child: appLogoWidget(context),
              ),
              Container(
                margin: EdgeInsets.only(top: App.height(context) * 0.35),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _entryField(
                      title: "Email ",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      obscure: false,
                      isPassword: false,
                      validate: (email) => (email.isEmpty)
                          ? "Please enter an email address"
                          : null,
                    ),
                    _entryField(
                      title: "Password",
                      icon: Icons.lock,
                      controller: _passwordController,
                      obscure: _isPassword,
                      isPassword: true,
                      validate: (pass) =>
                          (pass.isEmpty) ? "Please enter a password" : null,
                    ),
                    SizedBox(height: 20),
                    submitButton(
                      context: context,
                      text: "Login",
                      onTap: () async {
                        print("Validated ${_formKey.currentState!.validate()}");
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          FocusScope.of(context).unfocus();
                          var res = await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .signInWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          )
                              .then((value) async {
                            if (value >= 0) {
                              switch (value) {
                                case 0:
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "No user found for that email")));
                                    break;
                                  }
                                case 1:
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Wrong password provided for the user")));
                                    break;
                                  }
                              }
                            } else {
                              bool success = await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    content: Container(
                                      height: 80,
                                      padding: EdgeInsets.only(right: 30),
                                      child: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            'Please wait, authenticating...',
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (success) {
                                Navigator.of(context).push(
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: HomeScreen(),
                                  ),
                                );
                                _emailController.clear();
                                _passwordController.clear();
                              }
                            }
                          });
                        }
                      },
                    ),
                    _divider(),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Provider.of<AuthProvider>(context, listen: false)
                            .signInWithGoogle()
                            .whenComplete(() async {
                          bool success = await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                insetPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                content: Container(
                                  height: 80,
                                  padding: EdgeInsets.only(right: 30),
                                  child: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Please wait, authenticating...',
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          if (success) {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: HomeScreen(),
                              ),
                            );
                            _emailController.clear();
                            _passwordController.clear();
                          }
                        });
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        color: Color(0xFF4285F4),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 55,
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 20),
                              color: kWhiteColor,
                              child: Image.asset(
                                "assets/google_logo.png",
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _createAccount(),
                  ],
                ),
              ),
              Positioned(top: 40, left: 0, child: backButton(context)),
            ],
          ),
        ),
      ),
    ));
  }
}
