
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';


class Avatar extends StatelessWidget {
  final AssetImage image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = LightColors.bgGrey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: LightColors.grey,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? LightColors.kGrey
            : LightColors.kGrey,
            backgroundImage: image,
      ),
    );
  }
}