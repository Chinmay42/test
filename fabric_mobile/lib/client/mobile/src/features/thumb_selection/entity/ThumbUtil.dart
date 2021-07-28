


import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

import 'finger_selector.dart';

 class ThumbUtil
 {
   ThumbUtil._();

   static processWithPreviousSelection(FingerSelector fingerSelector,BuildContext context, Function function) {
     String selectedFinger = fingerSelector.isLeftHand?"Left Hand finger no. " +"${fingerSelector.select_finger}":"Right Hand finger no. " +"${fingerSelector.select_finger}";
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
           title: Row(
               children:[
                 Image.asset(fingerSelector.isLeftHand?'assets/left_hand.jpg':'assets/right_hand.jpg',width: MediaQuery.of(context).size.height/12, height: MediaQuery.of(context).size.height/12, fit: BoxFit.contain,),
                 SizedBox(width: 10,),
                 Text(selectedFinger,style: TextStyle(fontSize: MediaQuery.of(context).size.height/50,color: LightColors.grey),)
               ]
           ),
           content: Text("You have selected $selectedFinger for previous take. Would you like to perform verification with previous scan or change your finger"
           ,style:TextStyle(fontSize: MediaQuery.of(context).size.height/45,color:LightColors.grey)),
           actions: <Widget>[
             FlatButton(
               child: Text("Change Finger",style:TextStyle(fontSize: MediaQuery.of(context).size.height/45,color:LightColors.grey,fontWeight: FontWeight.bold)),
               onPressed: () {
                 //Put your code here which you want to execute on Cancel button click.
                 Navigator.of(context).pop();
                 function(false);

               },
             ),
             FlatButton(


               child: Text("Process",style:TextStyle(fontSize: MediaQuery.of(context).size.height/45,color:LightColors.grey,fontWeight: FontWeight.bold)),
               onPressed: () {
                 //Put your code here which you want to execute on Yes button click.
                 Navigator.of(context).pop(true);
                 function(true);

               },
             ),


           ],
         );
       },
     );
   }
 }