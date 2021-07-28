import 'dart:convert';
import 'dart:io';

import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/barcode_scanner/presentation/widgets/barcode_details.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/inviligator_creation/Inviligator_idproof_camera/invigilator_idproof_camera.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/inviligator_creation/camera_invigilator/camera_invigilator.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/inviligator_creation/camera_invigilator/shared/widgets/focus_widget.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/inviligator_creation/inviligator_object.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/inviligator_creation/inviligator_qr.dart';
import 'package:fabric_mobile/client/mobile/src/features/otp/presentation/widgets/otp_validate.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/data/models/sharepref_utils.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/widgets/profile_header.dart';
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

class FormInviligatorCreate extends StatefulWidget {
  FormInviligatorCreate();
  FormInviligatorCreateState createState() => new FormInviligatorCreateState();
  final bool androidFusedLocation = false;
}

class FormInviligatorCreateState extends State<FormInviligatorCreate> {
  @override
  void initState() {
    super.initState();
    this._outputController = TextEditingController();
  }

  String barcode;
  TextEditingController _outputController;

  final inviligatorname = TextEditingController();
  final inviligatorID = TextEditingController();
  final inviligatorMobile = TextEditingController();
  final invligatorLoginDuration = TextEditingController(text: '12');

  Map<String, dynamic> mapValue;
  String barcodedetail;
  File inviligatorImage;
  File invigilatorIDProofImage;

  final List<String> _dropdownValues = [
    "Select ID Proof",
    "Aadhar Card",
    "PAN Card",
    "Driving License",
    "Passport",
  ];

  String _value = 'Select ID Proof';

  CircleAvatar uploadedIcon() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height / 70,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.check,
        size: MediaQuery.of(context).size.height / 50,
        color: LightColors.white,
      ),
    );
  }

  CircleAvatar notUploadedIcon() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height / 70,
      backgroundColor: LightColors.kRed,
      child: Icon(Icons.close,
          size: MediaQuery.of(context).size.height / 50,
          color: LightColors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(

        //backgroundColor: LightColors.white,
        child: Container(
      margin: new EdgeInsets.symmetric(horizontal: 25.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LightColors.white,
                      border: Border.all(
                        color: LightColors
                            .grey, //                   <--- border color
                        width: 5.0,
                      ),
                    ),
                    width: MediaQuery.of(context).size.height / 6,
                    height: MediaQuery.of(context).size.height / 6,
                    child: inviligatorImage == null
                        ? InkWell(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => CameraInvigilator(
                                        mode: CameraInvigilatorMode.normal,
                                        onChangeCamera: (direction, _) {
                                          print('--------------');
                                          print('$direction');
                                          print('--------------');
                                        },
                                        imageMask: CameraFocus.circle(
                                          color: LightColors.black
                                              .withOpacity(0.5),
                                        ),
                                      )).then((value) {
                                setState(() {
                                  inviligatorImage = value;
                                });
                              });
                            },
                            child: Text(
                                'Click here\nto Upload\nInvigilator Image',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 60,
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold)))
                        : InkWell(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => CameraInvigilator(
                                        mode: CameraInvigilatorMode.normal,
                                        onChangeCamera: (direction, _) {
                                          print('--------------');
                                          print('$direction');
                                          print('--------------');
                                        },
                                        imageMask: CameraFocus.circle(
                                          color: LightColors.black
                                              .withOpacity(0.5),
                                        ),
                                      )).then((value) {
                                setState(() {
                                  inviligatorImage = value;
                                });
                              });
                            },
                            child: Image.file(
                              inviligatorImage,
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.height / 6,
                              fit: BoxFit.contain,
                            ))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
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
                          controller: inviligatorname,
                          autofocus: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(' ')
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              hintText: ('Enter Inviligator Name'),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(' ')
                          ],
                          controller: inviligatorID,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              hintText: "Enter Inviligator ID",
                              hintStyle: TextStyle(
                                  color: LightColors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 55),
                              suffixIcon: Icon(
                                Icons.domain_verification,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.height / 30,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        title: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: inviligatorMobile,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(' ')
                          ],
                          maxLength: 10,
                          autofocus: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              hintText: ('Enter Inviligator Mobile Number'),
                              hintStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.black,
                              ),
                              suffixIcon: Icon(
                                Icons.phone,
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
                          // enabled: false,
                          maxLength: 2,
                          //initialValue: "",
                          controller: invligatorLoginDuration,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          onChanged: (String value) {},
                          // ignore: deprecated_member_use
                          inputFormatters: [
                            FilteringTextInputFormatter.deny('0'),
                            FilteringTextInputFormatter.deny(' ')
                          ],
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50),
                              labelText: 'Login Duration',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              hintText: ('Inviligator Login Duration'),
                              hintStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.black,
                              ),
                              suffixIcon: Icon(
                                Icons.lock_clock,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.height / 30,
                              )),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            invigilatorIDProofImage != null
                                ? Text('Uploaded',
                                    style: TextStyle(
                                        color: LightColors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                60))
                                : Text('Not Uploaded',
                                    style: TextStyle(
                                        color: LightColors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                60)),
                            invigilatorIDProofImage != null
                                ? uploadedIcon()
                                : notUploadedIcon(),
                            Container(
                              width: MediaQuery.of(context).size.height / 6,
                              child: DropdownButton(
                                dropdownColor: LightColors.white,
                                onTap: () async {},
                                items: _dropdownValues
                                    .map((value) => DropdownMenuItem(
                                          child: Text('$value',
                                              style: TextStyle(
                                                  color: LightColors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          60)),
                                          value: value,
                                        ))
                                    .toList(),
                                onChanged: (String value) async {
                                  if (value != 'Select ID Proof') {
                                    await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CameraInvigilatorIDproof(
                                              mode: CameraInvigilatorIDproofMode
                                                  .normal,
                                              onChangeCamera: (direction, _) {
                                                print('--------------');
                                                print('$direction');
                                                print('--------------');
                                              },
                                              imageMask: CameraFocus.rectangle(
                                                color: LightColors.black
                                                    .withOpacity(0.5),
                                              ),
                                            )).then((value) {
                                      setState(() {
                                        invigilatorIDProofImage = value;
                                      });
                                    });
                                  } else {
                                    Toast.show(
                                        'Select a valid ID Proof', context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                  print(value);
                                  setState(() {
                                    _value = value;
                                  });
                                },
                                value: _value,
                              ),
                            )
                          ]),
                      SizedBox(height: 10.0),
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
                          },
                          backgroundColor: LightColors.kGrey,
                          buttonText: Text(
                            'Create',
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
    String iName = inviligatorname.text ?? "";
    String iID = inviligatorID.text ?? "";
    String iMobile = inviligatorMobile.text ?? "";
    String iLoginDuration = invligatorLoginDuration.text ?? "";

    if (inviligatorImage == null) {
      Toast.show('Please upload invigilator image!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (iName.isEmpty) {
      Toast.show('Please enter Inviligator name!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (iID.isEmpty) {
      Toast.show('Please enter Inviligator ID!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }
    if (iMobile.isEmpty) {
      Toast.show('Please enter Invigilator Mobile number!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }
    if (iLoginDuration.isEmpty) {
      Toast.show('Please enter login duration', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }
    if (invigilatorIDProofImage == null) {
      Toast.show('Please upload invigilator ID Proof!', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //fabric-admin user
    Map<String, dynamic> qrInvi = {
      'name': iName,
      'id': iID,
      'mobileNo': iMobile,
      'loginDuration': invligatorLoginDuration
    };

    Toast.show('Inviligator Created Successfully : $iName', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    InviligaltorPojo inviligator =
        InviligaltorPojo(iName, iID, iMobile, int.parse(iLoginDuration));

    String qrString = jsonEncode(inviligator);

    print(qrString);
    // print(inviligator['name']);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateQR(
          qr1: qrString,
          inviQR1: qrInvi,
        ),
      ),
    );
  }

  //barcode scanner

}
