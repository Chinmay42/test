import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessfulUploadScreen extends StatefulWidget {
//SharedPreferences prefs;
  @override
  _SuccessfulUploadScreenState createState() => _SuccessfulUploadScreenState();
}

class _SuccessfulUploadScreenState extends State<SuccessfulUploadScreen> {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Go to Profile again?',
              style: TextStyle(
                  color: LightColors.grey,
                  fontSize: MediaQuery.of(context).size.height / 52),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text(
                    'No',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 55),
                  )),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 55,
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: LightColors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: LightColors.white),
                padding: EdgeInsets.fromLTRB(25, 10, 25, 20),
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 1,
                      color: LightColors.kGrey,
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              InkWell(
                                onTap: () async {},
                                child: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.height / 7,
                                    backgroundColor: LightColors.kGreen,
                                    child: Icon(Icons.check,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        color: LightColors.white)),
                              ),
                              SizedBox(
                                height: 50,
                              ),

                              Text(
                                'Artifacts Submitted Successfully!',
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height / 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 50,
                              ),

                              // SizedBox(height: 30,),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
