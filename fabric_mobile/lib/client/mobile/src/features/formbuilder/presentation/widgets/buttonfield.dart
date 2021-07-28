import 'package:edge_alert/edge_alert.dart';
import 'package:fabric_mobile/client/mobile/config/AppConfig.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';

import 'package:flutter/material.dart';
//import 'package:oesapp/config/AppConfig.dart';

Widget createbuttonfield(
    BuildContext context,
    String buttontext,
    GlobalKey<FormState> _formKey,
    bool _autoValidate,
    Map<String, String> messages) {
      
  void _Save() {
    if (_formKey.currentState.validate()) {
      EdgeAlert.show(context,
          title: 'Title',
          description: messages.toString(),
          gravity: EdgeAlert.TOP);
    } else {
      _autoValidate = true;
    }
  }

  return Builder(builder: (context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: SizeConfig.screenWidth * 90,
        child: GestureDetector(
          onTap: _Save,
          child: Container(
              decoration: BoxDecoration(
               color: LightColors.kGrey,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                        color: LightColors.grey, //                   <--- border color
                       width: 2.0,
                ),
                
              ),
              width: SizeConfig.screenWidth * 100,
              height: 40,
              child: Center(
                child: Text(buttontext,
                    style: TextStyle(
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold,
                    )),
              )),
        ),
      ),
    );
  });
}
