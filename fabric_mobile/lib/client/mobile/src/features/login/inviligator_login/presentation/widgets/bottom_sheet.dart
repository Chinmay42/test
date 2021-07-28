import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomSheetChild extends StatelessWidget {
  var leadingIcon;
  var title;
  var tailingValue;
  BottomSheetChild({this.leadingIcon, this.title, this.tailingValue});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Icon(
            leadingIcon,
            color: LightColors.white,
            size: MediaQuery.of(context).size.height / 40,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(
                color: LightColors.white,
                fontSize: MediaQuery.of(context).size.height / 52),
          ),
          Spacer(),
          Text(
            tailingValue,
            style: TextStyle(
                color: LightColors.white,
                fontSize: MediaQuery.of(context).size.height / 52),
          )
        ],
      ),
    );
  }
}
