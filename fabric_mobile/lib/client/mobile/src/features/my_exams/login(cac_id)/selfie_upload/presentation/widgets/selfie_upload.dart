import 'dart:io';
import 'dart:typed_data';
import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'camera/camera_selfie.dart';
import 'camera/shared/widgets/focus_widget.dart';

class SelfieUpload extends StatefulWidget {
  final Uint8List bytespreview;

  SelfieUpload({
    Key key,
    this.bytespreview,
  }) : super(key: key);

  @override
  _SelfieUploadState createState() => _SelfieUploadState(
        bytespreview,
      );
}

class _SelfieUploadState extends State<SelfieUpload> {
  _SelfieUploadState(Uint8List bytespreview) {
    this.bytespreview1 = bytespreview;
  }

  SharedPreferences prefs;

  Uint8List bytespreview1;
  Position _currentPosition;
  String _currentAddress;
  String longitude;
  String latitude;
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  File selfieupload;
  BuildContext buildContext;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    initPlatformState();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        latitude = _currentPosition.latitude.toString();
        longitude = _currentPosition.longitude.toString();
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    double width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColors.kGrey,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: LightColors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Container(
                alignment: Alignment.center,
                width: width,
                child: Text(
                  'Upload your Selfie',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 45),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: LightColors.white,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Text('Welcome, John Doe',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40,
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LightColors.white,
                      border: Border.all(
                        color: LightColors
                            .grey, //                   <--- border color
                        width: 2.0,
                      ),
                    ),
                    width: MediaQuery.of(context).size.height / 3.5,
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: selfieupload == null
                        ? Text('Upload your\nSelfie here!',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 60,
                                color: LightColors.grey,
                                fontWeight: FontWeight.bold))
                        : Image.file(
                            selfieupload,
                            //height: MediaQuery.of(context).size.height / 6,
                            //width: MediaQuery.of(context).size.height / 6,
                            fit: BoxFit.contain,
                          )),
              ),
              SizedBox(
                height: 60.0,
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                title: SimpleRoundButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => CameraSelfie(
                              mode: CameraSelfieMode.normal,
                              onChangeCamera: (direction, _) {
                                print('--------------');
                                print('$direction');
                                print('--------------');
                              },
                              imageMask: CameraFocus.circle(
                                color: LightColors.black.withOpacity(0.5),
                              ),
                            )).then((value) {
                      setState(() {
                        selfieupload = value;
                      });
                    });
                  },
                  backgroundColor: LightColors.kGrey,
                  buttonText: Text(
                    'Take Selfie',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 55),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              selfieupload != null
                  ? ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      title: SimpleRoundButton(
                        onPressed: () {},
                        backgroundColor: LightColors.kGreen,
                        buttonText: Text(
                          'Proceed',
                          style: TextStyle(
                              color: LightColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height / 55),
                        ),
                      ),
                    )
                  : SizedBox(),
            ]),
      ),
    );
  }
}
