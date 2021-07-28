import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/inviligator_creation/inviligator_create.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/widgets/form.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';

class InviligatorCreateScreen extends StatefulWidget {
  const InviligatorCreateScreen({Key key}) : super(key: key);
  @override
  InviligatorCreateScreenState createState() =>
      new InviligatorCreateScreenState();
}

class InviligatorCreateScreenState extends State<InviligatorCreateScreen>
    with TickerProviderStateMixin {
  static FormFields form = new FormFields();
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
            title: new Text(
              'Go to CP Profile?',
              style: TextStyle(
                color: LightColors.grey,
                fontSize: MediaQuery.of(context).size.height / 52,
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No',
                    style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 55,
                    )),
              ),
              new FlatButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  //await prefs.setBool("isLogin", false);
                  Navigator.pushNamed(context, '/profile');
                },
                child: new Text('Yes',
                    style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 55,
                    )),
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
          appBar: AppBar(
            backgroundColor: LightColors.kGrey,
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 35,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      '       Create Inviligator',
                      style: TextStyle(
                          color: LightColors.grey,
                          fontSize: MediaQuery.of(context).size.height / 45),
                    ),
                  ),
                )
              ],
            ),
            centerTitle: true,
          ),
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
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      //Image.asset('assets/fabric_logo.png',fit: BoxFit.cover,height: MediaQuery.of(context).size.height/4,width: MediaQuery.of(context).size.height/4,),
                      SizedBox(
                        height: 10.0,
                      ),
                      FormInviligatorCreate(),
                    ],
                  ),
                ],
              ),
            ],
          ))),
        ));
  }
}
