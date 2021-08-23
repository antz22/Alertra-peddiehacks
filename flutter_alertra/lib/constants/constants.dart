import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF1B4EF5);
const kRedWarningColor = Color(0xFFF20000);
const kOrangeWarningColor = Color(0xFFF6A508);
const kYellowWarningColor = Color(0xFFFAE100);

const kDefaultPadding = 20.0;

kBoxShadow() {
  return BoxShadow(
    color: kPrimaryColor.withOpacity(0.20),
    spreadRadius: 1.0,
    blurRadius: 7.0,
    offset: Offset(0, 5),
  );
}
