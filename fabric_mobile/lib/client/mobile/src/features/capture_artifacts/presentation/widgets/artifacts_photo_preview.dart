import 'dart:io';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ArtifactsPhotoPreviewScreen extends StatefulWidget {
  File preview;

  ArtifactsPhotoPreviewScreen({
    Key key,
    this.preview,
  }) : super(key: key);

  @override
  _ArtifactsPhotoPreviewScreenState createState() =>
      _ArtifactsPhotoPreviewScreenState(preview);
}

class _ArtifactsPhotoPreviewScreenState
    extends State<ArtifactsPhotoPreviewScreen> {
  _ArtifactsPhotoPreviewScreenState(File preview) {
    this.preview1 = preview;
  }

  File preview1;
  SharedPreferences prefs;

  Position _currentPosition;
  String _currentAddress;
  String longitude;
  String latitude;
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  File _fingerprintImage;
  File _candidatePic;
  File _candidateId;
  File _candidateCounterFoil;

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

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 1,
            child: Container(
              // key: GlobalKeys.keyAssignProject,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: LightColors.white,
                border: Border.all(
                  color:
                      LightColors.grey, //                   <--- border color
                  width: 2.0,
                ),
              ),

              height: MediaQuery.of(context).size.height / 2.79,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Candiate Registration Photo",
                        style: TextStyle(
                            color: LightColors.grey,
                            fontSize: MediaQuery.of(context).size.height / 45),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 5.0),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/pass_photo.jpg',
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.height / 4,
                        fit: BoxFit.contain,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          // _buildHeader(),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: LightColors.white,
                          border: Border.all(
                            color: LightColors
                                .grey, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 2.79,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Candidate\nTake 1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: LightColors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              45),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ]),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              alignment: Alignment.center,
                              child: Container(
                                decoration:
                                    BoxDecoration(color: LightColors.white),
                                width: MediaQuery.of(context).size.height / 6,
                                height: MediaQuery.of(context).size.height / 6,
                                child: PhotoView(
                                  imageProvider: FileImage(preview1),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: LightColors.white,
                          border: Border.all(
                            color: LightColors
                                .grey, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 2.79,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Candidate\nTake 2",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: LightColors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              45),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              alignment: Alignment.center,
                              child: Container(
                                decoration:
                                    BoxDecoration(color: LightColors.white),
                                width: MediaQuery.of(context).size.height / 6,
                                height: MediaQuery.of(context).size.height / 6,
                                child: PhotoView(
                                  imageProvider: FileImage(preview1),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                              color: LightColors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  45,
                                            ),
                                          ),
                                          onTap: () {}),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                  ]),
                              visible: _fingerprintImage == null ? false : true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Get Photo Details',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 52,
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
                onTap: () {
                  _settingProjectsModalBottomSheet(context);
                }),
          )
        ],
      ),
    );
  }

  void _settingProjectsModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: LightColors.grey,
        context: context,
        elevation: 1.0,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Photo Detail',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 52),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BottomSheetChild(
                      leadingIcon: Icons.location_on,
                      title: 'Latitude :',
                      tailingValue:
                          latitude != null ? '$latitude' : "Unavailable",
                    ),
                    BottomSheetChild(
                      leadingIcon: Icons.location_on,
                      title: 'Longitude :',
                      tailingValue:
                          longitude != null ? '$longitude' : 'Unavailable',
                    ),
                    BottomSheetChild(
                      leadingIcon: Icons.pin_drop,
                      title: 'Current Area :',
                      tailingValue: _currentAddress != null
                          ? _currentAddress.toString()
                          : "Unavailable",
                    ),
                  ]));
        });
  }

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
                height: MediaQuery.of(context).size.height / 40,
                width: width,
                child: Text(
                  'Photo Preview',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 45),
                ),
              ),
            )
          ],
        ),
        //centerTitle: true,
      ),
      backgroundColor: LightColors.white,
      body: _buildBody(
          context), /*SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 35,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(color: LightColors.white),
                  width: MediaQuery.of(context).size.height / 2.2,
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: PhotoView(
                    imageProvider: FileImage(preview1),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Photo Details',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 45,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Card(
                  elevation: 1,
                  color: LightColors.kGrey,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(children: <Widget>[
                      Row(children: [
                        Container(
                          padding: new EdgeInsets.only(left: 10.0, top: 30.0),
                          child: Text(
                            'Latitude : ',
                            style: TextStyle(
                                color: LightColors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.only(top: 30.0),
                          child: Text(
                            latitude != null ? latitude : "Unavailable",
                            style: TextStyle(
                                color: LightColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: new EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Text(
                              'Longitude : ',
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.only(top: 0.0),
                            child: Text(
                              longitude != null ? longitude : "Unavailable",
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: new EdgeInsets.only(left: 10.0, top: 0.0),
                            child: Text(
                              'IMEI Number : ',
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.only(top: 0.0),
                            child: Text(
                              _platformImei != null
                                  ? _platformImei.toString()
                                  : "Unavailable",
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: new EdgeInsets.only(left: 10.0, top: 0.0),
                            child: Text(
                              'Address : ',
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.only(top: 0.0),
                            child: Text(
                              _currentAddress != null
                                  ? _currentAddress.toString()
                                  : "Unavailable",
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ]),
                  ),
                ),
              ),
            ]),
      ),*/
    );
  }
}
