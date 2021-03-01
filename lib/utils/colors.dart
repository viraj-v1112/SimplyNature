import 'package:flutter/material.dart';

class AppColors {
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color bgGray = Color(0xff19191b);
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);

  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static const Color mediumBlue = const Color(0xff4A64FE);
  static final Color iconColorInProfile = Colors.cyan;

  static final Color fgGray = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);
  static final Gradient fabGradient2 = LinearGradient(
      colors: [fgGray, receiverColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  static final Color gradientColorEnd = Colors.deepPurple;
  static final Color gradientColorStart = Colors.cyan;
  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  // static final String text =     ;
}
