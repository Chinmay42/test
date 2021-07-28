

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget
{
 String title;
 String description;
 IconData icon;
 CrossAxisAlignment crossAxisAlignment;
 MainAxisSize mainAxisSize;

 MyContainer({this.title,this.description,this.icon,this.crossAxisAlignment,this.mainAxisSize = MainAxisSize.min});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize:mainAxisSize ,
        crossAxisAlignment:crossAxisAlignment ,
        children: <Widget>[


        Icon(icon,color: Colors.white, size: MediaQuery.of(context).size.height/40,),

          Text(
            title, style: TextStyle(
              fontWeight: FontWeight.bold,
              color: LightColors.white,
              fontSize: MediaQuery.of(context).size.height/50),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
             description,
              style: TextStyle(color: LightColors.white,fontSize: MediaQuery.of(context).size.height/50),
            ),
          )
        ],
      ),
    );
  }
}
