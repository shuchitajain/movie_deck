import 'package:flutter/material.dart';

Widget appLogoWidget(BuildContext context) {
  return Container(
    height: 120,
    margin: EdgeInsets.symmetric(vertical: 20),
    width: MediaQuery.of(context).size.width/1.3,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          'assets/logo.png',
        ),
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}