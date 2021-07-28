import 'package:app_settings/app_settings.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/data/models/test.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/invigilatordetails.dart';
import 'package:fabric_mobile/client/mobile/src/features/permission/presentation/util/DialogUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SplashScreen> {
  BuildContext context;
  List<Permission> denied = [];
  List<String> reqirePermissionName = [];
  String appVersion = null;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Container(
        color: LightColors.white,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/fabric_logo.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('Fabric V${appVersion ?? '1.0.0'}',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: MediaQuery.of(context).size.height / 40,
                      color: LightColors.grey)),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermissionStatus();
    _InitPackageInfo();
  }

  Future<void> _checkPermissionStatus() async {
    var statusPhone = await Permission.phone.status;
    var statusLocation = await Permission.locationWhenInUse.status;
     var statusStorage = await Permission.storage.status;
    var statusCamera = await Permission.camera.status;
    var statusMicrophone = await Permission.microphone.status;

    denied = [];
    reqirePermissionName = [];

    if (statusPhone != PermissionStatus.granted) {
      denied.add(Permission.phone);
      reqirePermissionName.add('Phone');
    }

    if (statusLocation != PermissionStatus.granted) {
      denied.add(Permission.locationWhenInUse);
      reqirePermissionName.add('Location');
    }

    if (statusStorage != PermissionStatus.granted) {
      denied.add(Permission.storage);
      reqirePermissionName.add('Storage');
    }

    if (statusCamera != PermissionStatus.granted) {
      denied.add(Permission.camera);
      reqirePermissionName.add('Camera');
    }
    if (statusMicrophone != PermissionStatus.granted) {
      denied.add(Permission.microphone);
      reqirePermissionName.add('Microphone');
    }

    denied.length > 0 ? _requestForPermission(denied) : _moveToNext();
  }

  _requestForPermission(List<Permission> requirePermission) async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> permissionStatus =
        await requirePermission.request();
    denied = [];
    List<Permission> permanentlyDenied = [];
    permissionStatus.forEach((key, value) {
      if (value == PermissionStatus.denied) {
        denied.add(key);
      } else {
        if (value == PermissionStatus.permanentlyDenied) {
          permanentlyDenied.add(key);
        }
      }
    });

    // ignore: unnecessary_statements
    denied.length > 0
        ? DialogUtil.instance.showViewAgainPermissionDialog(
            context, _checkPermissionStatus, cancelFunction: _closeApp)
        : (permanentlyDenied.length > 0
            ? DialogUtil.instance.showMoveSettingDialog(
                context, reqirePermissionName,
                cancelFunction: _closeApp, operationFunction: _moveToAppSetting)
            : _moveToNext());
  }

  _moveToNext() {
    Future.delayed(Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLogin = prefs.getBool("isLogin") ?? false;

      print(' isLogin $isLogin');

      if (!isLogin) {
        Navigator.of(context).pushReplacementNamed('/loginoption');
        
      } else {
        
        Navigator.of(context).pushReplacementNamed('/loginoption');
         
      }
    });
  }

  //move to app setting
  _moveToAppSetting() {
    AppSettings.openAppSettings();
    SystemNavigator.pop();
  }

  //close app
  _closeApp() {
    SystemNavigator.pop();
  }

  Future<void> _InitPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
    });
  }
}
