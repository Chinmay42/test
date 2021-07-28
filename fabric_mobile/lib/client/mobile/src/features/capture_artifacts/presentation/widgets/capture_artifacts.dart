import 'dart:collection';
import 'dart:io';
import 'package:fabric_mobile/client/mobile/src/core/components/AppUtil.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/Consts.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/CustomDialog.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/bloc/aadhar_bloc.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/artifacts_photo_preview.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_ID/camera_id.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_ID/shared/widgets/focus_widget.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_counterfoil/camera_counterfoil.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/camera_counterfoil/shared/widgets/focus_widget.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/succesful_upload.dart';
import 'package:fabric_mobile/client/mobile/src/features/coach_mark/GlobalKeys.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/Util.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/artifects/artifectfile.dart';
import 'package:fabric_mobile/client/mobile/src/features/minio/minio_util.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/exam_details/presentation/pages/exam_detail.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/login(cac_id)/selfie_upload/presentation/widgets/camera/shared/widgets/focus_widget.dart';
import 'package:fabric_mobile/client/mobile/src/features/thumb_selection/entity/ThumbUtil.dart';
import 'package:fabric_mobile/client/mobile/src/features/thumb_selection/entity/finger_selector.dart';
import 'package:fabric_mobile/client/mobile/src/features/thumb_selection/thumb_selector.dart';
import 'package:fabric_mobile/client/mobile/src/features/upload_status/presentation/widgets/candidate_upload_stats_list.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'package:toast/toast.dart';
import 'dart:isolate';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'camera/camera.dart';

class CaptureArtifactsScreen extends StatefulWidget {
  bool getPreviousTake = false;

  CaptureArtifactsScreen({Key key, this.getPreviousTake}) : super(key: key);
  // Obtain a list of the available cameras on the device.
  @override
//bool getPreviousTake=false;
  _CaptureArtifactsScreenState createState() =>
      _CaptureArtifactsScreenState(getPreviousTake);
}

class _CaptureArtifactsScreenState extends State<CaptureArtifactsScreen> {
  _CaptureArtifactsScreenState(bool getPreviousTake) {
    this.getPreviousTake = getPreviousTake ?? false;
  }

  AnimationController animationController;
  File _fingerprintImage;
  File _candidatePic;
  File _candidateId;
  File _candidateCounterFoil;
  BuildContext buildContext;
  TargetPlatform platform;
  ProgressDialog pr;
  bool getPreviousTake;
  FingerSelector fingerSelector;
  bool biometricVerify = false;
  int _takeNo;
  final _apk = [
    {
      'name': 'APK File',
      'link':
          'http://59.165.234.14:8796/owncloud/index.php/s/CDW0okm9EArkBgi/download'
    },
  ];

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;

  String _localPath;
  ReceivePort _port = ReceivePort();
  static const platform1 = const MethodChannel('get.data/Scanner');
  SharedPreferences prefs;
  String longitude;
  String latitude;
  List<TargetFocus> targets = List();

  AadharBloc _bloc;
  TextEditingController adh_no_controller = new TextEditingController();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(debug: false);
    //di.init();
    super.initState();
    _bindBackgroundIsolate();
    _bloc = AadharBloc();
    FlutterDownloader.registerCallback(downloadCallback);

    _prepare().then((value) {
      if (getPreviousTake) _getTakePhoto();
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Cancel uploading all the artifacts?',
              style: TextStyle(
                  color: LightColors.grey,
                  fontSize: MediaQuery.of(context).size.height / 52),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.pop(context),
                child: new Text(
                  'No',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height / 55),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes',
                    style: TextStyle(
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height / 55,
                    )),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: LightColors.white,
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
                    '      Capture Candidate Artifacts',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontSize: MediaQuery.of(context).size.height / 45),
                  ),
                ),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: SpinCircleBottomBarHolder(
          // key: GlobalKeys.keyAssignProject,
          bottomNavigationBar: SCBottomBarDetails(
              circleColors: [
                LightColors.white,
                LightColors.kGrey,
                LightColors.grey
              ],
              iconTheme: IconThemeData(color: LightColors.grey, size: 35),
              activeIconTheme: IconThemeData(color: LightColors.grey, size: 35),
              backgroundColor: LightColors.kGrey,
              actionButtonDetails: SCActionButtonDetails(
                  color: LightColors.kGreen,
                  icon: Icon(
                    Icons.expand_less,
                    size: MediaQuery.of(context).size.height / 25,
                    color: LightColors.white,
                    key: GlobalKeys.keyAssignProject,
                  ),
                  elevation: 2),
              elevation: 2,
              items: [
                // Suggested count : 4
                SCBottomBarItem(
                    icon: null,
                    //Icons.home,
                    onPressed: () {
                      Navigator.pushNamed(context, "/home");
                    }),
                SCBottomBarItem(
                    icon: null,
                    //Icons.perm_contact_calendar,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamDetailScreen(
                            animationController: animationController,
                          ),
                        ),
                      );
                    }),
                SCBottomBarItem(
                    icon: null, // Icons.list,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadStatsListScreen(
                            animationController: animationController,
                          ),
                        ),
                      );
                    }),
                SCBottomBarItem(
                    icon: null,
                    // Icons.perm_identity,
                    onPressed: () {}),
              ],
              circleItems: _setCircleItemList(),
              bnbHeight:
                  MediaQuery.of(context).size.height / 11 // Suggested Height 80
              ),

          child: SingleChildScrollView(
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    buildContext = context;
    platform = Theme.of(context).platform;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          // _buildHeader(),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(children: <Widget>[
                  Card(
                    //candidate photo
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
                          Container(
                            padding: EdgeInsets.only(top: 5.0),
                            alignment: Alignment.center,
                            child: _candidatePic == null
                                ? InkWell(
                                    onTap: () {
                                      Toast.show('Candidate Photo not uploaded',
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    },
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: LightColors.grey,
                                      size: MediaQuery.of(context).size.height /
                                          5,
                                    ))
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArtifactsPhotoPreviewScreen(
                                                    preview: _candidatePic,
                                                  )));
                                    },
                                    child: Image.file(
                                      _candidatePic,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Candidate\nPhoto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: LightColors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                45),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                _candidatePic == null
                                    ? notUploadedIcon()
                                    : uploadedIcon(),
                              ])
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Stack(children: [
                    Card(
                      //idproof
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 1,
                      child: Container(
                        // key: GlobalKeys.keyAssignProject,
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
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              alignment: Alignment.center,
                              child: _candidateId == null
                                  ? InkWell(
                                      onTap: () {
                                        Toast.show(
                                            'ID Proof not Uploaded', context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                      },
                                      child: Icon(
                                        Icons.file_upload,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        color: LightColors.grey,
                                      ))
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArtifactsPhotoPreviewScreen(
                                                      preview: _candidateId,
                                                    )));
                                      },
                                      child: Image.file(
                                        _candidateId,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        fit: BoxFit.contain,
                                      )),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ID Proof",
                                      style: TextStyle(
                                          color: LightColors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              45),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  _candidateId == null
                                      ? notUploadedIcon()
                                      : uploadedIcon(),
                                ]),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _takeNo == 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: LightColors.kGrey,
                            border: Border.all(
                              color: LightColors
                                  .grey, //                   <--- border color
                              width: 2.0,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height / 2.75,
                        ))
                  ]),
                ]),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Card(
                      //fingerprint
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
                            Container(
                                padding: EdgeInsets.only(top: 5.0),
                                alignment: Alignment.center,
                                child: _fingerprintImage == null
                                    ? InkWell(
                                        onTap: () {
                                          Toast.show('Fingerprint not Uploaded',
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                        },
                                        child: Icon(
                                          Icons.fingerprint,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          color: LightColors.grey,
                                        ))
                                    : Image.asset(
                                        'assets/fingerprint.png',
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        fit: BoxFit.contain,
                                      )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Biometrics",
                                      style: TextStyle(
                                          color: LightColors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              45),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  _fingerprintImage == null
                                      ? notUploadedIcon()
                                      : uploadedIcon(),
                                ]),
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
                                          biometricVerify
                                              ? "Verified"
                                              : "Verify",
                                          style: TextStyle(
                                              color: LightColors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  45,
                                              decoration: biometricVerify
                                                  ? TextDecoration.none
                                                  : TextDecoration.underline),
                                        ),
                                        onTap: () {
                                          if (!biometricVerify &&
                                              _fingerprintImage != null) {
                                            _performOperation(true);
                                            /*ThumbUtil
                                                .processWithPreviousSelection(
                                                    fingerSelector,
                                                    buildContext,
                                                    _performOperation);

                                          */
                                          } else {
                                            print("on tap");
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    biometricVerify
                                        ? uploadedIcon()
                                        : notUploadedIcon(),
                                  ]),
                              visible: _fingerprintImage == null ? false : true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Stack(
                      children: [
                        Card(
                          //counterfoil
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
                                Container(
                                  padding: EdgeInsets.only(top: 5.0),
                                  alignment: Alignment.center,
                                  child: _candidateCounterFoil == null
                                      ? InkWell(
                                          onTap: () {
                                            Toast.show(
                                                'Counterfoil not Uploaded',
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          },
                                          child: Icon(
                                            Icons.camera_front,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5,
                                            color: LightColors.grey,
                                          ))
                                      : InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ArtifactsPhotoPreviewScreen(
                                                          preview:
                                                              _candidateCounterFoil,
                                                        )));
                                          },
                                          child: Image.file(
                                            _candidateCounterFoil,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            fit: BoxFit.contain,
                                          ) //color: LightColors.grey,)
                                          ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Counterfoil",
                                          style: TextStyle(
                                              color: LightColors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  45),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      _candidateCounterFoil == null
                                          ? notUploadedIcon()
                                          : uploadedIcon(),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                            visible: _takeNo == 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: LightColors.kGrey,
                                border: Border.all(
                                  color: LightColors
                                      .grey, //                   <--- border color
                                  width: 2.0,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height / 2.75,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          SimpleRoundButton(
            buttonText: _candidatePic == null ||
                    _candidateId == null ||
                    _candidateCounterFoil == null ||
                    _fingerprintImage == null ||
                    biometricVerify == false
                ? Text('Submit Artifacts',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 50))
                : Text(
                    'Submit Artifacts',
                    style: TextStyle(
                        color: LightColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 50),
                  ),
            backgroundColor: _candidatePic == null ||
                    _candidateId == null ||
                    _candidateCounterFoil == null ||
                    _fingerprintImage == null ||
                    biometricVerify == false
                ? LightColors.kGrey
                : LightColors.kGreen,
            onPressed: () async {
              if (_takeNo == 1 && _candidatePic !=null && _fingerprintImage != null && biometricVerify ) {
                _uploadFileToMinio();
              }
               
              else {
                if (_candidatePic != null &&
                    _candidateId != null &&
                    _candidateCounterFoil != null &&
                    _fingerprintImage != null) {
                  if (biometricVerify) {
                    _uploadFileToMinio();
                  } else {
                    Toast.show('Please verify biometric!', context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                } else
                  Toast.show('Please Upload all the Artifacts!', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            },
          ),
        ],
      ),
    );
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

  void checkForApplication(String value) async {
    var isAvaible = await Consts.checkAppAvailable(value);

    if (isAvaible)
      _fingerSelection(false);
    else
      checkPermissionForDownload(value);
  }

  void onThumbClick() async {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: Consts.title,
          buttonTextFirst: Consts.morpho,
          buttonTextSecond: Consts.mantra,
        ),
      ).then((value) => checkForApplication(value));
    });
  }

  void checkPermissionForDownload(value) async {
    Permission permission = Permission.storage;
    var status = await permission.status;
    permissionStatus(status, permission, value);
  }

  void permissionStatus(
      PermissionStatus permissionStatus, Permission permission, value) {
    switch (permissionStatus) {
      case PermissionStatus.undetermined:
        {
          callForPermission(permission, value);
          break;
        }
      case PermissionStatus.granted:
        {
          downloadApkFor(value);
          break;
        }

      case PermissionStatus.denied:
        {
          showDialog(
                  context: buildContext,
                  builder: (BuildContext context) {
                    return Consts.showAlertForCheckAgain(
                        permission, buildContext);
                  })
              .then((value1) =>
                  {if (value1) callForPermission(permission, value)});
          break;
        }

      case PermissionStatus.restricted:
        {
          Consts.showAlert(buildContext, Consts.restricted);
          break;
        }

      case PermissionStatus.permanentlyDenied:
        {
          openAppSettings().then((value) => checkPermissionForDownload(value));
          break;
        }
    }
  }

  Future<void> callForPermission(Permission permission, String value) async {
    final status = await permission.request();
    permissionStatus(status, permission, value);
  }

  void downloadApkFor(value) {
    downloadCode();
  }

  Future<void> launchApp() async {
    print('launch app');
    String response;
    try {
      prefs.setBool("biometricVerify", false);
      final result = await platform1.invokeMethod('launchApp2');

      setState(() {
        _fingerprintImage = new File(result);

        //  _storeInHive();
      });
      Toast.show("Biometric Scan successfully!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on PlatformException catch (e) {
      print(e.toString());
      String value = 'Please try again for Biometric Scanner.';
      setState(() {
        errorAlert(value);
      });
    }
  }

  Future<void> _launchAppForVerification() async {
    String response;
    try {
      Toast.show(_fingerprintImage.path, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      final result = await platform1.invokeMethod(
          'launchAppForVerification', {"path": _fingerprintImage.path});
      setState(() {
        prefs.setBool("biometricVerify", true);
        biometricVerify = true;
        Toast.show(" Verification Successful", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      });
    } on PlatformException catch (e) {
      print(e.toString());
      String value = e.message;
      setState(() {
        errorAlert(value);
      });
    }
  }

  void errorAlert(String error) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Error"),
      content: Text(error),
      actions: [
        RaisedButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(buildContext);
          },
        )
      ],
    );
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  //:::::::::::::::::::::::::::; Download Apk

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void downloadCode() {
    showCustomDialog();
    _requestDownload(_tasks[0]);
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      if (false) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }

      if (task.status == DownloadTaskStatus.complete) {
        pr.hide();
        _openDownloadedFile(task);
      } else if (task.status == DownloadTaskStatus.failed) {
        FlutterDownloader.cancel(taskId: id);
        await pr.hide();
        Consts.showAlert(buildContext, Consts.download_failed);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (true) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _requestDownload(_TaskInfo task) async {
    print('PATH : $_localPath');
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    //onClickInstallApk();
    FlutterDownloader.open(taskId: task.taskId)
        .then((value) => print("Is install successfully $value"));
  }

  Future<Null> _prepare() async {
    prefs = await SharedPreferences.getInstance();
    final tasks = await FlutterDownloader.loadTasks();

    String empId = prefs.getString("Emp_id"); // scane user Id

    String projectName = prefs.getString("Project_Name");
    String key = '$empId$projectName';
    int count = prefs.getInt(key) ?? 0;

    setState(() {
      _takeNo = prefs.getInt("TakeNumber") ?? 1; // your initiated take
    });

    print('Take Number is $_takeNo');
    _tasks = [];
    _items = [];

    _tasks.addAll(_apk.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'APK'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }
    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
    //Path Creation
    _localPath = (await AppUtil.findLocalPath(platform, 'Download'));

    print('Local Path $_localPath');
  }

  void showCustomDialog() {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(message: 'File downloading....');

    pr.show();
  }

  Future<void> _uploadFileToMinio() async {
    /*Toast.show(_fingerprintImage.path, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
*/
    List<File> myList = [];
    myList.add(_candidatePic);
    myList.add(_fingerprintImage);

    if (_takeNo == 2) {
      myList.add(_candidateId);
      myList.add(_candidateCounterFoil);
    }

    MiniOUtil().checkCreateBucket();
    await MiniOUtil().uploadFile(myList, fingerSelector);

    Toast.show('Uploaded', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessfulUploadScreen(),
      ),
    );
  }

  _fingerSelection(bool forcefullySelectFinger) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ThumbSelector()),
    );

    fingerSelector = result;
    launchApp();
  }

  _performOperation(bool value) {
    print(value);
    if (value) {
      _launchAppForVerification();
    } else {
      _fingerSelection(true);
    }
  }

  void _getTakePhoto() {
    String empId = prefs.getString("Emp_id"); // scane user Id

    String projectName = prefs.getString("Project_Name");
    String key = '$empId$projectName';
    int count = prefs.getInt(key) ?? 0;

    Util.getArtifectFileDetailsForUserTake(empId, 'Take $count', projectName)
        .then((value) {
      setState(() {
        print(empId + 'Take $count');
        print('setState ${value.length}');
        List<ArtifectFile> list = value;

        if (list != null && list.length > 0) {
          list.forEach((element) {
            switch (element.fileFor) {
              case Util.fileForPhoto:
                _candidatePic = File(element.filePath);
                break;
              case Util.fileForBiometric:
                _fingerprintImage = File(element.filePath);
                fingerSelector = new FingerSelector(
                    element.biometricHandFinger, element.biometricHand);
                break;
              case Util.fileForId:
                _candidateId = File(element.filePath);
                break;
              case Util.fileForCounterfoil:
                _candidateCounterFoil = File(element.filePath);
                break;
            }
          });
        } else // create empty file
        {}
      });
    });
  }

  _setCircleItemList() {
    List<SCItem> list = [];

    //Suggested Count: 3
    SCItem idProofItem = SCItem(
        icon: Icon(Icons.file_upload,
            color: LightColors.grey,
            size: MediaQuery.of(context).size.height / 30),
        onPressed: () async {
          if (_candidatePic != null && _fingerprintImage != null) {
            if (biometricVerify) {
              return await showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      title: Column(
                        children: <Widget>[
                          Text('Upload any ID Proof',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 52,
                                  color: LightColors.grey,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Icon(
                            Icons.file_upload,
                            color: LightColors.grey,
                            size: MediaQuery.of(context).size.height / 15,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('Scan for Valid ID Proof ',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                              'Please Click the OK button to start the uploading process.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey,
                              )),
                        ],
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey),
                          ),
                        ),
                        new FlatButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => CameraID(
                                      mode: CameraMode1.normal,
                                      //initialCamera: CameraSide.front,
                                      //enableCameraChange: false,
                                      //  orientationEnablePhoto: CameraOrientation.landscape,
                                      onChangeCamera: (direction, _) {
                                        print('--------------');
                                        print('$direction');
                                        print('--------------');
                                      },

                                      imageMask: CameraFocusID.square(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    )).then((value) {
                              setState(() {
                                _candidateId = value;
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: new Text(
                            'OK',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            } else {
              Toast.show('Verify fingerprint first', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          } else
            Toast.show('Upload fingerprint first', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
    SCItem counterfoilItem = SCItem(
        icon: Icon(Icons.camera_front,
            color: LightColors.grey,
            size: MediaQuery.of(context).size.height / 30),
        onPressed: () async {
          if (_candidatePic != null &&
              _candidateId != null &&
              _fingerprintImage != null) {
            if (biometricVerify) {
              return await showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      title: Column(
                        children: <Widget>[
                          Text('Upload Counterfoil',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 52,
                                  color: LightColors.grey,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Icon(
                            Icons.camera_front,
                            color: LightColors.grey,
                            size: MediaQuery.of(context).size.height / 15,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                              'Please Click the OK button to start the uploading process.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey,
                              )),
                        ],
                      ),
                      actions: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        new FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey),
                          ),
                        ),
                        new FlatButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => CameraCounterfoil(
                                      mode: CameraMode2.normal,
                                      initialCamera: CameraSide2.front,
                                      //enableCameraChange: false,
                                      //  orientationEnablePhoto: CameraOrientation.landscape,
                                      onChangeCamera: (direction, _) {
                                        print('--------------');
                                        print('$direction');
                                        print('--------------');
                                      },

                                      imageMask: CameraFocusCounterfoil.square(
                                        color:
                                            LightColors.black.withOpacity(0.5),
                                      ),
                                    )).then((value) {
                              setState(() {
                                _candidateCounterFoil = value;
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: new Text(
                            'OK',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 55,
                                color: LightColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            } else {
              Toast.show('Verify fingerprint first', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          } else
            Toast.show('upload ID Proof first', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });

    list.add(
      SCItem(
          icon: Icon(Icons.photo_camera,
              color: LightColors.grey,
              size: MediaQuery.of(context).size.height / 30),
          onPressed: () async {
            return await showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    title: Column(
                      children: <Widget>[
                        Text(
                          'Upload Candidate Photo',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 52,
                              color: LightColors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Icon(
                          Icons.photo_camera,
                          color: LightColors.grey,
                          size: MediaQuery.of(context).size.height / 15,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            'Scan for passport size photograph only with blue background',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 55,
                              color: LightColors.grey,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            'Please Click the OK button to start the uploading process.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 55,
                              color: LightColors.grey,
                            )),
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text(
                          'CANCEL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height / 55,
                              color: LightColors.grey),
                        ),
                      ),
                      new FlatButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => Camera(
                                    mode: CameraMode.normal,
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
                              _candidatePic = value;
                            });
                          });
                          Navigator.pop(context);
                        },
                        //Navigator.pushReplacementNamed(context, "/home"),
                        child: new Text(
                          'OK',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height / 55,
                              color: LightColors.grey),
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
          }),
    );
    list.add(SCItem(
        icon: Icon(Icons.fingerprint,
            color: LightColors.grey,
            size: MediaQuery.of(context).size.height / 30),
        onPressed: () async {
          /*return await showDialog(
                                  context: context,
                                    child: new AlertDialog(
                                        title: Column(
                                         children: <Widget>[
                                            SizedBox(height: 10.0,),
                                            
                                            Text('Please Enter your 15 digit Aadhar Number',style: TextStyle(fontSize: MediaQuery.of(context).size.height/52,color: LightColors.grey,fontWeight: FontWeight.bold),),
                                            SizedBox(height:20.0),
                                            ListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              title:TextFormField(
                                              controller: adh_no_controller,
                                              autofocus: false,
                                              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                              hintText : ('   Enter Your 15 Digit Aadhar Number'),
                                              hintStyle: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/60),
                                              suffixIcon:  Icon(Icons.person_outline,color: LightColors.grey,size:MediaQuery.of(context).size.height/40)),
                                              ),
                                          ),
                                               ],
                                        ),
              
                                      actions: <Widget>[
                                        new FlatButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                            child: new Text('CANCEL',style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey),),
                                        ),
                                        new FlatButton(
                                          child: new Text('OK',style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey)),
                                          onPressed: () {
                                          // _bloc.add_aadhar(adh_no_controller.text, "1").then((value) {
                                           //   if (value.err == false)
                                             // {

                                            //checkForApplication('Morpho');

                                          */
          if (_candidatePic != null) {
            onThumbClick();
          } else {
            Toast.show('upload candidate image first', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          /* // }
                                             // else
                                             // {
                                              //  Toast.show(value.data, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                             // }
                                           //});
                                          },
                                                //Navigator.pushReplacementNamed(context, "/home"),
                                            
                                        ),
                                     ],
                              ),
                          ) ?? false;
                   */
        }));
    list.add(idProofItem);
    list.add(counterfoilItem);

    if (_takeNo.compareTo(1) == 0) {
      list.removeAt(2);
      list.removeAt(2);
    }
    return list;
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
