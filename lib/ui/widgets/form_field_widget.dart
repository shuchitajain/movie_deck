import 'package:flutter/material.dart';

Widget formFieldWidget({
  required String title,
  required TextEditingController controller,
  TextInputType keyboard = TextInputType.text,
  FormFieldValidator<String>? validator,
  required Function onTap,
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
          maxLines: title.contains("Description") ? 4 : 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            errorStyle: TextStyle(
              fontSize: 14,
            ),
            contentPadding: EdgeInsets.only(left: 8, top: 17, bottom: 8),
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
