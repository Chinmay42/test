import 'dart:convert';

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_option.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/invigilator_model.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/invigilatordetails.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/widgets/qr_details.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';

class LoginWithQR extends StatefulWidget {
  LoginWithQR({Key key, String name, this.title}) : super(key: key);

  final String title;

  @override
  _LoginWithQRState createState() => _LoginWithQRState();
}

class _LoginWithQRState extends State<LoginWithQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  static String qrMsg = '';

  var qrText = "";
  QRViewController controller;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Scan QR Code Again?',
              style: TextStyle(color: LightColors.grey, fontSize: 15.0),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(
                      color: LightColors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginOptions(),
                    ),
                  );
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(
                      color: LightColors.grey, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Card(
                    elevation: 1,
                    color: LightColors.kGrey,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Scan the Invigilator QR Code here',
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50),
                            ),
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: LightColors.kBlue,
                      borderRadius: MediaQuery.of(context).size.height / 80,
                      borderLength: MediaQuery.of(context).size.height / 60,
                      borderWidth: MediaQuery.of(context).size.height / 90,
                      cutOutSize: MediaQuery.of(context).size.height / 3.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0, left: 5.0, right: 5.0),
                  child: Card(
                    elevation: 1,
                    color: LightColors.kGrey,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        'Please place the QR code inside the square\nScan will automatically start',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: LightColors.grey,
                            fontSize: MediaQuery.of(context).size.height / 50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      try {
        Map<String, dynamic> map = jsonDecode(qrText);
        InvigilatorModel model = InvigilatorModel.fromJson(map);
        // Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvigilatorProfileScreen(
                      model1: model,
                    )));

        controller.pauseCamera();
      } catch (ex) {
        Toast.show('Invalid QR code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        controller.resumeCamera();
      }
    });
  }
}
