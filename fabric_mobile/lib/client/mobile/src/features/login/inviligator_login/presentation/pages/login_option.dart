import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/login_with_qr.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/bottom_sheet.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Are you sure you want to exit?',
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
                onPressed: () {
                  SystemNavigator.pop();
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

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersistantBottomSheetCallBack;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/fabric_logo.png',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.height / 4,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                            color: LightColors.kGrey,
                            elevation: 1,
                            child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.all(15),
                                child: Column(children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Toast.show('This Feature is Under Development', context,
                                          gravity: Toast.BOTTOM,
                                          duration: Toast.LENGTH_LONG);
                                      //Navigator.of(context)
                                      //  .pushReplacementNamed('/login');
                                    },
                                    child: CustomButton(
                                      buttonTitle: 'Login with ID',
                                      icon: Icons.account_box,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginWithQR()));
                                    },
                                    child: CustomButton(
                                      buttonTitle: 'Login with QR',
                                      icon: Icons.qr_code,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ])))
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Get Details',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 52,
                                color: LightColors.grey,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        onTap: _showPersistantBottomSheetCallBack,
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    _showPersistantBottomSheetCallBack = _showBottomSheet;
  }

  void _showBottomSheet() {
    setState(() {
      _showPersistantBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return Builder(builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: LightColors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  BottomSheetChild(
                    leadingIcon: Icons.description,
                    title: 'IMEI No:',
                    tailingValue: '975757-7874837ASD',
                  ),
                  BottomSheetChild(
                    leadingIcon: Icons.phone_android,
                    title: 'Mobile No:',
                    tailingValue: '96857585758',
                  ),
                  BottomSheetChild(
                    leadingIcon: Icons.location_on,
                    title: 'Latitude:',
                    tailingValue: '123.45.67.6',
                  ),
                  BottomSheetChild(
                    leadingIcon: Icons.location_on,
                    title: 'Longitude:',
                    tailingValue: '76.657.89.90',
                  ),
                  BottomSheetChild(
                    leadingIcon: Icons.pin_drop,
                    title: 'Current Area',
                    tailingValue: 'Udaipur,Rajasthan',
                  ),
                ],
              ),
            );
          });
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersistantBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }
}
