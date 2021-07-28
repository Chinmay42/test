import 'dart:io';

import 'package:fabric_mobile/client/mobile/src/core/components/tabIcon_data.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/capture_artifacts.dart';
import 'package:fabric_mobile/client/mobile/src/features/coach_mark/GlobalKeys.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/gridmodel.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/pages/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'package:toast/toast.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView(
      {Key key, this.tabIconsList, this.changeIndex, this.addClick})
      : super(key: key);

  final Function(int index) changeIndex;
  final Function addClick;
  final List<TabIconData> tabIconsList;
  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    _sharePreference();
    initPlatformState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                color: LightColors.kGrey,
                elevation: 16.0,
                clipper: TabClipper(
                    radius: Tween<double>(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn))
                            .value *
                        38.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList[0],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList[0]);
                                  widget.changeIndex(0);
                                },
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                  key: GlobalKeys.keyExamSloat,
                                  tabIconData: widget.tabIconsList[1],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[1]);
                                    widget.changeIndex(1);
                                  }),
                            ),
                            SizedBox(
                              width: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn))
                                      .value *
                                  64.0,
                            ),
                            Expanded(
                              child: TabIcons(
                                  key: GlobalKeys.keyUserList,
                                  tabIconData: widget.tabIconsList[3],
                                  //height: 20.0,
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[3]);
                                    widget.changeIndex(3);
                                  }),
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[4],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[4]);
                                    widget.changeIndex(4);
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: 38 * 2.0,
            height: 38 + 62.0,
            child: Container(
              width: MediaQuery.of(context).size.height / 60,
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: SizedBox(
                width: 38 * 2.0,
                height: 38 * 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Curves.fastOutSlowIn)),
                    child: Container(
                      key: GlobalKeys.keyScanner,
                      // alignment: Alignment.center,s
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(50),
                        color: LightColors.kGreen,
                        gradient: LinearGradient(
                            colors: [
                              LightColors.kGreen,
                              LightColors.kGreen,
                              //HexColor('#6A88E5'),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: LightColors.kGreen.withOpacity(0.4),
                              offset: const Offset(8.0, 16.0),
                              blurRadius: 16.0),
                        ],
                      ),
                      child: Material(
                        // key: GlobalKeys.keyScanner,
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            _settingProjectsModalBottomSheet(context);

                            widget.addClick();
                          },
                          child: Icon(
                            Icons.scanner,
                            //key: GlobalKeys.keyScanner,
                            size: MediaQuery.of(context).size.height / 30,
                            // key: GlobalKeys.keyScanner,
                            color: LightColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }

  SharedPreferences prefs;

  Future<void> _sharePreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _settingProjectsModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        elevation: 1.0,
        builder: (BuildContext bc) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5.0),
                  child: Text(
                    'Select a Project',
                    style: TextStyle(
                        color: LightColors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 52),
                  ),
                ),
                // SizedBox(height: 10.0,),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(15.0),
                    children: _getGridItemList().map((list) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                              leading: Icon(list.icons,
                                  color: LightColors.grey,
                                  size:
                                      MediaQuery.of(context).size.height / 40),
                              title: Text(list.title,
                                  style: TextStyle(
                                      color: LightColors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              55)),
                              onTap: () async {
                                await prefs.setString(
                                    "Project_Name", list.title);
                                print(MediaQuery.of(context).size.height / 12);
                                Toast.show(
                                    'Project Selected : ${list.title}', context,
                                    gravity: Toast.BOTTOM,
                                    duration: Toast.LENGTH_LONG);
                                return showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                        title: Column(
                                          children: <Widget>[
                                            Text(
                                                'Select a storage you want to store the images.',
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            55,
                                                    color: LightColors.grey,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              leading: Icon(Icons.storage,
                                                  color: LightColors.grey,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      40),
                                              title: Text("Internal Storage",
                                                  style: TextStyle(
                                                      color: LightColors.grey,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              55,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text(
                                                _storageInfo.length > 0
                                                    ? '${_storageInfo[0].availableGB.toString()} GB'
                                                    : "Unavailable",
                                                style: TextStyle(
                                                    color: LightColors.grey,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            55),
                                              ),
                                              onTap: () async {
                                                if (_storageInfo.length > 0) {
                                                  return showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            new AlertDialog(
                                                          title: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Select what do you want to scan',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.height /
                                                                              52,
                                                                      color: LightColors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              ListTile(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            4),
                                                                leading: Icon(
                                                                    Icons
                                                                        .scanner,
                                                                    color:
                                                                        LightColors
                                                                            .grey,
                                                                    size: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        40),
                                                                title: Text(
                                                                    "BARCODE",
                                                                    style: TextStyle(
                                                                        color: LightColors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.height /
                                                                                55)),
                                                                onTap:
                                                                    () async {
                                                                  scanBarcodeNormal();
                                                                },
                                                              ),
                                                              Divider(
                                                                color:
                                                                    LightColors
                                                                        .grey,
                                                              ),
                                                              ListTile(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            4),
                                                                leading: Icon(
                                                                    Icons
                                                                        .scanner,
                                                                    color:
                                                                        LightColors
                                                                            .grey,
                                                                    size: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        40),
                                                                title: Text(
                                                                    "QR-CODE",
                                                                    style: TextStyle(
                                                                        color: LightColors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.height /
                                                                                55)),
                                                                onTap:
                                                                    () async {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              QRPage(),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ) ??
                                                      false;
                                                } else {
                                                  Toast.show(
                                                      'Storage Unavailable can\'t proceed',
                                                      context,
                                                      gravity: Toast.BOTTOM,
                                                      duration:
                                                          Toast.LENGTH_LONG);
                                                }
                                              },
                                            ),
                                            Divider(
                                              color: LightColors.grey,
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              leading: Icon(Icons.sd_storage,
                                                  color: LightColors.grey,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      40),
                                              title: Text("External Storage",
                                                  style: TextStyle(
                                                      color: LightColors.grey,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              55,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text(
                                                _storageInfo.length > 1
                                                    ? '${_storageInfo[1].availableGB.toString()} GB'
                                                    : "Unavailable",
                                                style: TextStyle(
                                                    color: LightColors.grey,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            55),
                                              ),
                                              onTap: () async {
                                                if (_storageInfo.length > 1) {
                                                  return showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            new AlertDialog(
                                                          title: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Select what do you want to scan',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.height /
                                                                              52,
                                                                      color: LightColors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  scanBarcodeNormal();
                                                                },
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            4),
                                                                leading: Icon(
                                                                    Icons
                                                                        .scanner,
                                                                    color:
                                                                        LightColors
                                                                            .grey,
                                                                    size: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        40),
                                                                title: Text(
                                                                    "BARCODE",
                                                                    style: TextStyle(
                                                                        color: LightColors
                                                                            .grey,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.height /
                                                                                55,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              Divider(
                                                                color:
                                                                    LightColors
                                                                        .grey,
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              QRPage(),
                                                                    ),
                                                                  );
                                                                },
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            4),
                                                                leading: Icon(
                                                                    Icons
                                                                        .scanner,
                                                                    color:
                                                                        LightColors
                                                                            .grey,
                                                                    size: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        40),
                                                                title: Text(
                                                                    "QRCODE",
                                                                    style: TextStyle(
                                                                        color: LightColors
                                                                            .grey,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.height /
                                                                                55,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ) ??
                                                      false;
                                                } else {
                                                  Toast.show(
                                                      'Storage Unavailable can\'t proceed',
                                                      context,
                                                      gravity: Toast.BOTTOM,
                                                      duration:
                                                          Toast.LENGTH_LONG);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ) ??
                                    false;
                              }), //988998
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Divider(
                              color: LightColors.grey,
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                    // Divider(),
                  ),
                ),
              ]);
        });
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

  String _scanBarcode = 'Unknown';

  List<GridModel> _getGridItemList() {
    List<GridModel> list = new List<GridModel>();
    list.add(new GridModel(Icons.library_books, "TANGO 1", LightColors.kGreen));
    list.add(new GridModel(Icons.library_books, "TANGO 2", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 3", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 4", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 5", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 6", LightColors.kGreen));
    list.add(new GridModel(Icons.library_books, "TANGO 7", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 8", LightColors.grey));
    list.add(new GridModel(Icons.library_books, "TANGO 9", LightColors.grey));
    return list;
  }

  String barcode = "";
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

  // Platform messages are asynchronous, so we initialize in an async method.
  /*Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
    //  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //      "#ff6666", "Close", false, ScanMode.BARCODE);
      print(barcodeScanRes);
      Toast.show(barcodeScanRes, context,
          gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);

      // ignore: unrelated_type_equality_checks
      if (barcodeScanRes == '-1') {
        // Navigator.pop(context);
      } else {
        Toast.show(barcodeScanRes, context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaptureArtifactsScreen(),
            ));
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;

      //Map<String,dynamic> map = jsonDecode(_scanBarcode);
    });
  }*/
}

class TabIcons extends StatefulWidget {
  const TabIcons(
      {Key key,
      this.tabIconData,
      this.removeAllSelect,
      double height,
      double width,
      this.color})
      : super(key: key);

  final TabIconData tabIconData;
  final Function removeAllSelect;
  final Color color;
  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect();
          widget.tabIconData.animationController.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.tabIconData.animationController,
                          curve:
                              Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
                  child: Icon(
                    widget.tabIconData.icons,
                    color: LightColors.grey,
                    size: MediaQuery.of(context).size.height / 30,
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData.animationController,
                            curve: Interval(0.2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: LightColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData.animationController,
                            curve: Interval(0.5, 0.8,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: LightColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData.animationController,
                            curve: Interval(0.5, 0.6,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: LightColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }
}
