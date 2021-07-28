import 'package:app_settings/app_settings.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_option.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/permission/presentation/util/DialogUtil.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/data/models/sharepref_utils.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/widgets/profile_header.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/widgets/user_info.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/pages/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => new ProfileScreenState();
  final bool androidFusedLocation = false;
}

class ProfileScreenState extends State<ProfileScreen> {
  BuildContext context;
  List<Permission> denied = [];
  List<String> reqirePermissionName = [];
  @override
  void initState() {
    super.initState();

    //initPlatformState();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Are you sure you want to Logout?',
              style: TextStyle(
                  color: LightColors.grey,
                  fontSize: MediaQuery.of(context).size.height / 52),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(
                    'No',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 55),
                  )),
              new FlatButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  //fabric-admin user

                  await prefs.setBool("isLogin", false);

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

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getId();

      print("platformImei" + platformImei);
      SharedPrefUtils.IMEI = platformImei;

      print('shared_pref' + SharedPrefUtils.IMEI);
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: LightColors.kGrey,
              automaticallyImplyLeading: false,
              title: Text(
                'CP Profile Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: LightColors.grey,
                    fontSize: MediaQuery.of(context).size.height / 45),
              ),
              elevation: 2,
            ),
            backgroundColor: LightColors.white,
            extendBodyBehindAppBar: true,
            extendBody: true,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    //   avatar: CachedNetworkImageProvider('https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'),
                    avatar: AssetImage(
                      'assets/avatar.jpg',
                    ),
                    title: "John Doe",
                    actions: <Widget>[], coverImage: null,
                  ),
                  SizedBox(height: 5.0),
                  UserInfo(),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: SimpleRoundButton(
                          buttonText: Text(
                            'Create Invigilator',
                            style: TextStyle(
                                color: LightColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                          ),
                          backgroundColor: LightColors.kGrey,
                          onPressed: () {
                            // Navigator.of(context)
                            //   .pushReplacementNamed('/inviligatorcreate');
                            _moveToCreate();
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: SimpleRoundButton(
                          buttonText: Text(
                            'View Invigilator',
                            style: TextStyle(
                                color: LightColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                          ),
                          backgroundColor: LightColors.kGrey,
                          onPressed: () {
                            //_checkPermissionStatus();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )));
  }

  

  _moveToCreate() {
    Navigator.pushNamed(context, '/inviligatorcreate');
  }
}
