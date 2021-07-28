//AppConfig.width = MediaQuery.of(context).size.width;
//AppConfig.height = MediaQuery.of(context).size.height;
//AppConfig.blockSize = AppConfig.width / 100;
//AppConfig.blockSizeVertical = AppConfig.height / 100;

//double fontSize = AppConfig.blockSize * 1.2;

//double elementWidth = AppConfig.blockSize * 10.0; // 10% of the screen width

//AppConfig.safeAreaHorizontal = MediaQuery.of(context).padding.left +
//  MediaQuery.of(context).padding.right;

//double screenWidthWithoutSafeArea = AppConfig.width - AppConfig.safeAreaHorizontal;

//SizeConfig().init(context);

import 'package:flutter/widgets.dart';

class Appconfig {
  static String baseurl = 'abcd';
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width / 100;
    screenHeight = _mediaQueryData.size.height / 100;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
