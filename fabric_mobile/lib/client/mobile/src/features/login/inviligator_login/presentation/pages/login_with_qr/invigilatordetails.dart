import 'package:app_settings/app_settings.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/capture_artifacts.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_option.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/invigilator_model.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/permission/presentation/util/DialogUtil.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/data/models/sharepref_utils.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/widgets/profile_header.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/widgets/user_info.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/pages/qr_scan.dart';
import 'package:fabric_mobile/client/mobile/src/features/upload_status/presentation/widgets/candidate_upload_stats_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class InvigilatorProfileScreen extends StatefulWidget {
  final Map<String, dynamic> inviQR1;
  final InvigilatorModel model1;
  final String qr1;
  InvigilatorProfileScreen({this.inviQR1, this.qr1, this.model1});
  @override
  InvigilatorProfileScreenState createState() =>
      new InvigilatorProfileScreenState(inviQR1, qr1, model1);
  final bool androidFusedLocation = false;
}

class InvigilatorProfileScreenState extends State<InvigilatorProfileScreen> {
  Map<String, dynamic> inviQR2;
  InvigilatorModel model2;
  var qr2;

  BuildContext context;
  List<Permission> denied = [];
  List<String> reqirePermissionName = [];
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  InvigilatorProfileScreenState(
      Map<String, dynamic> inviQR1, String qr1, InvigilatorModel model1) {
    this.inviQR2 = inviQR1;
    this.qr2 = qr1;
    this.model2 = model1;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Scan Again',
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

  String barcode = '';

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
      // Map<String, dynamic> barcodeMap = jsonDecode(barcode);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CaptureArtifactsScreen(),
        ),
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

  List<StorageInfo> _storageInfo = [];

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
    });
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
              automaticallyImplyLeading: true,
              title: Text(
                'Invigilator Profile Details',
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
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    //   avatar: CachedNetworkImageProvider('https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'),
                    avatar: AssetImage(
                      'assets/avatar.jpg',
                    ),
                    title: model2.inName ??= "Unavailable",
                    actions: <Widget>[], coverImage: null,
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Information",
                      style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Card(
                    color: LightColors.kGrey,
                    elevation: 1,
                    child: Container(
                      //height: MediaQuery.of(context).size.height/1.99,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          //SizedBox(height: 5.0,),

                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            leading: Icon(Icons.domain_verification,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.width / 15),
                            title: Text("Invigilator ID",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            30)),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(model2.inIdNumber ??= "Unavailable",
                                  style: TextStyle(
                                      color: LightColors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30)),
                            ),
                          ),
                          //SizedBox(height: 5.0,),
                          Divider(
                            color: LightColors.grey,
                          ),
                          //SizedBox(height: 5.0,),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            leading: Icon(Icons.phone,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.width / 15),
                            title: Text("Mobile No.",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            30)),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(model2.inPhoneNo ??= "Unavailable",
                                  style: TextStyle(
                                      color: LightColors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30)),
                            ),
                          ),
                          Divider(
                            color: LightColors.grey,
                          ),
                          //SizedBox(height: 5.0,),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            leading: Icon(Icons.dock_rounded,
                                color: LightColors.grey,
                                size: MediaQuery.of(context).size.width / 15),
                            title: Text("Exam ID",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            30)),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(model2.examId ??= "Unavailable",
                                  style: TextStyle(
                                      color: LightColors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30)),
                            ),
                          ),
                          //SizedBox(height: 5.0,),
                          //SizedBox(height: 15.0),

                          //],
                          // )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  SimpleRoundButton(
                    buttonText: Text(
                      'Scan Candidate QR',
                      style: TextStyle(
                          color: LightColors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 30),
                    ),
                    backgroundColor: LightColors.kGrey,
                    onPressed: isStorageSelected,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SimpleRoundButton(
                    buttonText: Text(
                      'Scanned Candidate List',
                      style: TextStyle(
                          color: LightColors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 30),
                    ),
                    backgroundColor: LightColors.kGrey,
                    onPressed: () {
                      // Navigator.of(context)
                      //   .pushReplacementNamed('/inviligatorcreate');
                      // _checkPermissionStatus();
                      _moveToList();
                    },
                  ),
                ],
              ),
            )));
  }

  _moveToList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      List<String> list = prefs.getStringList('user_list');

      if (list == null) list = [];

      print('view detail ${list.length}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadStatsListScreen(
                    userList: list,
                  )));
    });
    //Navigator.pushNamed(context, '/home');
  }

  isStorageSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isPreviousSelectd = prefs.getBool('storage_selected') ?? false;

    isPreviousSelectd
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRPage()))
        : showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: Column(
                children: <Widget>[
                  Text('Select a storage you want to store the images.',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 55,
                          color: LightColors.grey,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5.0,
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(Icons.storage,
                        color: LightColors.grey,
                        size: MediaQuery.of(context).size.height / 40),
                    title: Text("Internal Storage",
                        style: TextStyle(
                            color: LightColors.grey,
                            fontSize: MediaQuery.of(context).size.height / 55,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      _storageInfo.length > 0
                          ? '${_storageInfo[0].availableGB.toString()} GB'
                          : "Unavailable",
                      style: TextStyle(
                          color: LightColors.grey,
                          fontSize: MediaQuery.of(context).size.height / 55),
                    ),
                    onTap: () async {
                      if (_storageInfo.length > 0) {
                        prefs.setBool('storage_selected', true);

                        Navigator.pop(context);
                        _moveForScaneQr();
                      } else {
                        Toast.show(
                            'Storage Unavailable can\'t proceed', context,
                            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                      }
                    },
                  ),
                  Divider(
                    color: LightColors.grey,
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(Icons.sd_storage,
                        color: LightColors.grey,
                        size: MediaQuery.of(context).size.height / 40),
                    title: Text("External Storage",
                        style: TextStyle(
                            color: LightColors.grey,
                            fontSize: MediaQuery.of(context).size.height / 55,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      _storageInfo.length > 1
                          ? '${_storageInfo[1].availableGB.toString()} GB'
                          : "Unavailable",
                      style: TextStyle(
                          color: LightColors.grey,
                          fontSize: MediaQuery.of(context).size.height / 55),
                    ),
                    onTap: () async {
                      if (_storageInfo.length > 1) {
                        prefs.setBool('storage_selected', true);

                        Navigator.pop(context);
                        _moveForScaneQr();
//                         Navigator.of(context).pop();
                      } else {
                        Toast.show(
                            'Storage Unavailable can\'t proceed', context,
                            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
  }

  void _moveForScaneQr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("Project_Name", model2.examId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRPage(),
      ),
    );
  }
}
