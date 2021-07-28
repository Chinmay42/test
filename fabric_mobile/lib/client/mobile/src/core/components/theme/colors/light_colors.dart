import 'package:flutter/material.dart';

class LightColors  {
   
  static const Color kGrey = Color(0xF6F6F6F6);
  static const Color bgGrey = Color(0x7E7E7E7E);
  static const Color kRed = Color(0xFFE46472);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kGreen = Color(0xFF309397);
  static const Color black = Color(0xFF0D253F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF3A5160);

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
