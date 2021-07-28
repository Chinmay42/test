import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  var buttonTitle;
  var icon;
  final Color backgroundColor;
  final Color textColor;
  final Function onPressed;

  CustomButton(
      {this.buttonTitle,
      this.icon,
      this.backgroundColor,
      this.textColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 15,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 42),
        color: LightColors.grey,
        boxShadow: [
          BoxShadow(
            color: LightColors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              buttonTitle,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 52,
                fontWeight: FontWeight.bold,
                color: LightColors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 7,
              height: MediaQuery.of(context).size.height / 20,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(18),
                color: LightColors.white,
              ),
              child: Icon(icon,
                  color: LightColors.grey,
                  size: MediaQuery.of(context).size.height / 30),
            )
          ],
        ),
      ),
    );
  }
}
