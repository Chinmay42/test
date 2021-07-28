



import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/login(cac_id)/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key,this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  SignInScreenState createState() => new SignInScreenState();
}

class SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {

AnimationController animationController;


 static TextFields field= new TextFields();
 static String cac_id;
  static String pass2;


 Widget tabBody = Container(
    color: LightColors.white,
  );


  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
  
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new Scaffold(
          backgroundColor: LightColors.white,   
          body:
          FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  
                   new Container(

                child: new Container(

                  child: new ListView(
          
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height:40.0),
                              Image.asset('assets/fabric_logo.png',fit: BoxFit.cover,height: MediaQuery.of(context).size.height/4,width: MediaQuery.of(context).size.height/4,),
                              SizedBox(height: 5.0,),

                              TextFields(),
                             
                                
                             
                            ],
                          ),
                          //bottomBar(),
                        ],
                      ),
                    ],
                  ))),
    
               
                ],
              );
            }
          },
    ),
    
    )
    );
    
  }

Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

}
