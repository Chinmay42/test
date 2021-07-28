
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

TextStyle  getPermissionDialogTextStyle(BuildContext context,{double size,Color color}) {
  return TextStyle(
    color: color??LightColors.grey,
    /*fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,*/
    fontSize: size ??=MediaQuery.of(context).size.height/45,
  );
}


TextStyle  getPermissionDialogButtonStyle(BuildContext context) {
  return TextStyle(
    fontWeight: FontWeight.bold,
    color: LightColors.grey,
    /*fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,*/
    fontSize: MediaQuery.of(context).size.height/45,
  );
}