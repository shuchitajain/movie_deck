import 'package:flutter/material.dart';

Widget formFieldWidget({
  required String title,
  required TextEditingController controller,
  TextInputType keyboard = TextInputType.text,
  FormFieldValidator<String>? validator,
  required Function onTap,
  required IconData icon,
  bool obscure = false,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscure,
          onTap: () => onTap(),
          keyboardType: keyboard,
          maxLines: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            hintText: title == "Movie name"
                ? "Sherlock Holmes"
                : title == "Director name"
                    ? "Guy Ritchie"
                    : "Detective Sherlock Holmes and his stalwart partner Watson engage in a battle of wits and brawn with a nemesis whose plot is a threat to all of England.",
            prefixIcon: Icon(icon),
            filled: true,
            errorStyle: TextStyle(
              fontSize: 14,
            ),
            contentPadding: EdgeInsets.only(left: 8, top: 14, bottom: 8),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
