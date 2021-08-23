import 'package:flutter/material.dart';
import 'package:flutter_alertra/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.purpose,
    required this.text,
    this.fit = 'fill',
  }) : super(key: key);

  final String purpose;
  final String text;
  final String fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: purpose == 'warning' ? Color(0xFFE30000) : kPrimaryColor,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          kBoxShadow(),
        ],
      ),
      width: fit == 'fill'
          ? MediaQuery.of(context).size.width - 2 * kDefaultPadding
          : MediaQuery.of(context).size.width - 5 * kDefaultPadding,
      height: 52.0,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
