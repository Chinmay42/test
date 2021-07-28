import 'dart:convert';

import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/barcode_scanner/presentation/widgets/barcode_details.dart';
import 'package:fabric_mobile/client/mobile/src/features/otp/presentation/widgets/otp_validate.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/data/models/sharepref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
//import 'package:access_settings_menu/access_settings_menu.dart';

class FormFields extends StatefulWidget {
  FormFields();
  FormFieldsState createState() => new FormFieldsState();
  final bool androidFusedLocation = false;
}

class FormFieldsState extends State<FormFields> {
  @override
  void initState() {
    super.initState();
    this._outputController = TextEditingController();
  }

  String barcode;
  TextEditingController _outputController;



  final username = TextEditingController();
  final password1 = TextEditingController();

  Map<String, dynamic> mapValue;
  String barcodedetail;

  @override
  Widget build(BuildContext context) {
    print('height : ${MediaQuery.of(context).size.height}');
    print('widht : ${MediaQuery.of(context).size.width}');
    print(MediaQuery.of(context).size);
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 25.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: LightColors.kGrey,
                elevation: 1,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        title: TextFormField(
                          controller: username,
                          autofocus: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              hintText: ('Enter Your Username'),
                              hintStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.black,
                              ),
                              suffixIcon: Icon(
                                Icons.person_outline,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.height / 30,
                              )),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        title: TextFormField(
                          autofocus: false,
                          controller: password1,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              hintText: "Enter your Password",
                              hintStyle: TextStyle(
                                  color: LightColors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 55),
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.height / 30,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: LightColors.grey,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        title: SimpleRoundButton(
                          onPressed: () {
                            _isValidUser();
                            //scanBarcodeNormal();
                            //scan();
                          },
                          backgroundColor: LightColors.kGrey,
                          buttonText: Text(
                            'Login',
                            style: TextStyle(
                                color: LightColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    ));
  }

  _isValidUser() async {
    String name = username.text ?? "";
    String password = password1.text ?? "";

    if (name.isEmpty) {
      Toast.show('Please enter username !', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (password.isEmpty) {
      Toast.show('Please enter password!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //fabric-admin user
    if (name == (prefs.getString("userName") ?? "fabric_admin") &&
        password == (prefs.getString("password") ?? "abc123")) {
      await prefs.setBool("isLogin", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OTP(),
        ),
      );

      //fabric_admin1 user redirect to barcode scanner
    } else if (name == (prefs.getString("userName") ?? "fabric_admin1") &&
        password == (prefs.getString("password") ?? "abc1234")) {
      await prefs.setBool("isLogin", true);

      scanBarcodeNormal();
      //scan(); //navigate to barcode scanner

    } else {
      Toast.show('You have entered an invalid username or password!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //barcode scanner

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print('Scane Result is $barcodeScanRes');
      setState(() {
        barcode = barcodeScanRes;
      });
      Map<String, dynamic> barcodeMap = jsonDecode(barcode);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BarCodeDetailsPage(
                  barcodeDetails: barcodeMap,
                )),
      );
    } on Exception catch (exception) {
      print('Exception is ${exception.toString()}');
    } catch (error) {
      print('Error is ${error.toString()}');
    }
    print(' Scane Result is $barcodeScanRes');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print(' Scane Result is $barcodeScanRes');
  }
}
