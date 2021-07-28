

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/widgets/form.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}




class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {


 static FormFields form= new FormFields();
 static String username;
  static String pass;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
  
  
    super.dispose();
  }

  
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
           builder: (_) => new AlertDialog(
            title: new Text('Do you want to go back?',style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/52,),),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No',style: TextStyle(color: LightColors.grey,fontSize:MediaQuery.of(context).size.height/55,)),
              ),
              new FlatButton(
                onPressed: () {
                  
                      Navigator.pushNamed(context, '/loginoption');
                  },
                  
                child: new Text('Yes',style: TextStyle(color: LightColors.grey,fontSize:MediaQuery.of(context).size.height/55,)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
   
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          backgroundColor: LightColors.white,
          body: new Container(

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
                              SizedBox(height: 10.0,),
                              FormFields(),
                                  
                                
                            ],
                          ),
                        ],
                      ),
                    ],
                  ))),
        ));
  }





}
