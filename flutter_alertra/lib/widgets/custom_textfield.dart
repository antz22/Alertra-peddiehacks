import 'package:flutter/material.dart';
import 'package:flutter_alertra/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.verbose = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool verbose;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hintText.contains('Password') ? true : false,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFEEEEEE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(width: 2, color: kPrimaryColor),
        ),
      ),
      keyboardType: verbose ? TextInputType.multiline : TextInputType.text,
      maxLines: verbose ? 10 : 1,
    );
  }
}
