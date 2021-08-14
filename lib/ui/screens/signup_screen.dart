import 'package:flutter/material.dart';
import 'package:movie_deck/repository/user_repository.dart';
import 'package:movie_deck/ui/config.dart';
import 'package:movie_deck/ui/screens/login_screen.dart';
import 'package:movie_deck/ui/widgets/app_logo_widget.dart';
import 'package:movie_deck/ui/widgets/back_button_widget.dart';
import 'package:movie_deck/ui/widgets/bezier_container_widget.dart';
import 'package:movie_deck/ui/widgets/reusable_button_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPassword = true;

  void _toggle() {
    setState(() {
      _isPassword = !_isPassword;
    });
  }

  Widget _entryField(String title, IconData icon, TextEditingController controller, obscure, isPassword) {
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
          TextField(
            key: Key(title),
            obscureText: obscure,
            controller: controller,
            keyboardType: !isPassword ? TextInputType.emailAddress : TextInputType.text,
            onSubmitted: (val) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: !isPassword ? "shuchitajain99@gmail.com" : "******",
              prefixIcon: Icon(
                  icon,
              ),
              suffix: isPassword ? InkWell(
                child: Icon(Icons.remove_red_eye, color: kBlackColor, size: 20,),
                onTap: (){
                  _toggle();
                },
              ) : null,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _loginLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: LoginScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(
            text: 'Already have an account ?  ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: kBlackColor,
            ),
            children: [
              TextSpan(
                text: 'Login',
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
      body: SingleChildScrollView(
        child: Container(
          height: App.height(context),
          child: Stack(
            children: <Widget>[
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
                margin: EdgeInsets.only(top: App.height(context) * 0.25),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _entryField("Email ", Icons.email_outlined, _emailController, false, false),
                    _entryField("Password", Icons.lock, _passwordController, _isPassword, true),
                    SizedBox(
                      height: 30,
                    ),
                    submitButton(
                      context: context,
                      text: "Register",
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Provider.of<AuthProvider>(context, listen: false).signUpWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HomeScreen(),
                          ),
                        );
                        _emailController.clear();
                        _passwordController.clear();
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    _loginLabel(),
                  ],
                ),
              ),
              Positioned(top: 40, left: 0, child: backButton(context)),
            ],
          ),
        ),
      ),
    );
  }
}
