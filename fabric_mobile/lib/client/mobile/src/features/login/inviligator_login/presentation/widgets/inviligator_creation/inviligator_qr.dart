import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/invigilatordetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
  final Map<String, dynamic> inviQR1;
  final String qr1;
  GenerateQR({this.inviQR1, this.qr1});
  @override
  _GenerateQRState createState() => _GenerateQRState(inviQR1, qr1);
}

class _GenerateQRState extends State<GenerateQR> {
  Map<String, dynamic> inviQR2;

  var qr2;

  var _globalKey = GlobalKey();

  _GenerateQRState(Map<String, dynamic> inviQR1, String qr1) {
    this.inviQR2 = inviQR1;
    this.qr2 = qr1;
  }

  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Create another Inviligator?',
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
                  Navigator.pushNamed(context, '/inviligatorcreate');
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

  String qrData = "https://github.com/ChinmayMunje";
  final qrdataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: LightColors.kGrey,
          //Appbar having title

          body: SingleChildScrollView(
            //Scroll view given to Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),
                Text(
                  'Welcome ${inviQR2['name']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height / 35,
                      color: LightColors.grey),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: QrImage(
                        data: qr2,
                        backgroundColor: LightColors.white,
                        foregroundColor: LightColors.black,
                        size: MediaQuery.of(context).size.height / 2.5,
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: 20),
                Text(
                  'Please Scan this QR Code from the\n Inviligator\'s Device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height / 50,
                      color: LightColors.grey),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                SimpleRoundButton(
                  buttonText: Text(
                    'Go to Invigilator Profile',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 30),
                  ),
                  backgroundColor: LightColors.kGrey,
                  onPressed: () {
                    //_saveQrImage();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InvigilatorProfileScreen(
                                  inviQR1: inviQR2,
                                )));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _saveQrImage() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getExternalStorageDirectory();
      final file =
          await new File('${tempDir.path}/${inviQR2['name']}_QR.png').create();
      // print(file);
      print("PATH : ${file.path}");
      await file.writeAsBytes(pngBytes).then((value) => print(value.path));
    } catch (e) {
      print(e.toString());
    }
  }
}
