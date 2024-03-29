import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import "package:flutter/material.dart";

class SimpleRoundButton extends StatelessWidget {

  final Color backgroundColor;
  final Text buttonText;
  final Color textColor;
  final Function onPressed;

  SimpleRoundButton({
    this.backgroundColor,
    this.buttonText,
    this.textColor,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 7.0),
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Row(
        children: <Widget>[
          
          new Expanded(
            child: FlatButton(
              
              shape: new RoundedRectangleBorder(
                  side: BorderSide(color: LightColors.grey,width: 3),
                  borderRadius: new BorderRadius.circular(30.0)),
              color: this.backgroundColor,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: buttonText,
                  ),
                ],
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}