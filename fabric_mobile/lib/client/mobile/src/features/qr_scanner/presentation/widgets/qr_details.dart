import 'dart:io';

import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/presentation/widgets/capture_artifacts.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/Util.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/artifects/artifectfile.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class QRDetailsPage extends StatefulWidget {
  QRDetailsPage({Key key, this.title, context, this.str1}) : super(key: key);
  final Map<String, dynamic> str1;

  final String title;

  @override
  _QRDetailsPageState createState() => _QRDetailsPageState(str1, title);
}

class _QRDetailsPageState extends State<QRDetailsPage>
    with TickerProviderStateMixin {
  _QRDetailsPageState(Map<String, dynamic> str1, String title) {
    this.toast = str1;
    this.jsontitle = title;
  }
  String jsontitle;
  SharedPreferences prefs;
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  ScrollController _scrollController = new ScrollController();

  File _candidateImage;
  File _fingerprintImage;
  File _counterfoilImage;
  File _idProof;
  int pill_index = 0;
  int take_length;

  static List<String> AttdList = [];

  static List<String> DCVDList = [];

  List<bool> event_button_vis = [true, true];
  List<List<String>> event_list = [AttdList, DCVDList];
  int event_item = 0;
  String dropdownValue = 'DCVD';
  int _radioValue = 0;
  String selectedChoice;
  Map<String, dynamic> toast;
  List<String> event_name = ["Attendance", "DCVD"];
  bool _dropdownShown = false;

  @override
  void initState() {
    super.initState();
    _sharePreference().then((value) {
      _saveUser(widget.title);
      _getTotalTake();
    });
  }

  void _saveUser(String title) async {
    List<String> userList = prefs.getStringList('user_list');
    userList ??= [];
    userList.add(jsontitle);

    await prefs.setStringList('user_list', userList);
  }

  Future<void> _sharePreference() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("Emp_id", toast['registrationNumber']);
  }

  void _toggleDropdown() {
    setState(() {
      _dropdownShown = !_dropdownShown;
    });
  }

  Widget dropdown_event_menu() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        style: TextStyle(
            color: LightColors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['DCVD', 'Attendance']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Scan QR Code Again?',
              style: TextStyle(
                  color: LightColors.grey,
                  fontSize: MediaQuery.of(context).size.height / 55),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
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
                child: new Text(
                  'Yes',
                  style: TextStyle(
                    color: LightColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 55,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget event_tab() {
    return Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: ValueListenableBuilder(
              valueListenable: _currentPageNotifier,
              builder: (context, value, child) {
                return Text(
                  event_name[value],
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 55,
                      fontWeight: FontWeight.bold),
                );
              },
            )),

        new Spacer(), // I just added one line

        Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: ValueListenableBuilder(
              valueListenable: _currentPageNotifier,
              builder: (context, value, child) {
                return Visibility(
                    visible: event_button_vis[value],
                    child: InkWell(
                      child: Icon(Icons.add,
                          color: LightColors.kRed,
                          size: MediaQuery.of(context).size.height / 40),
                      onTap: () {
                        int count = event_list[value].length + 1;
                        prefs.setString("TakeNo", "Take $count");
                        prefs.setInt('TakeNumber', count);

                        setState(() {
                          event_list[value].add("Take " +
                              (event_list[value].length + 1).toString());
                          event_button_vis[value] = false;
                        });
                      },
                    ));
              },
            ))
      ],
    );
  }

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        itemCount: 2,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  Widget takein_chips_list(int val) {
    List<Widget> choices = List();

    event_list[val].forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 3,
        ),
        child: ChoiceChip(
          backgroundColor: LightColors.kBlue,
          label: Text(
            item,
            style: TextStyle(
                color: LightColors.white,
                fontSize: MediaQuery.of(context).size.height / 60),
          ),
          selected: selectedChoice == item,
          onSelected: (selected) {
            _settingModalBottomSheet(context, item.toString());
            _getTakePhoto(item.toString());
          },
        ),
      ));
    });
    return Wrap(children: choices);
  }

  Widget page_pills() {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: PageView.builder(
          itemCount: 2,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: takein_chips_list(index),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  Widget _appBar() {
    double width = MediaQuery.of(context).size.width * 0.8;
    return new AppBar(
      backgroundColor: LightColors.kGrey,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Candidate Information',
        style: TextStyle(
            color: LightColors.grey,
            fontSize: MediaQuery.of(context).size.height / 45),
      ),
    );
  }

  static CircleAvatar closeIcon() {
    return CircleAvatar(
      radius: 15.0,
      backgroundColor: LightColors.kRed,
      child: Icon(Icons.close, size: 20.0, color: LightColors.white),
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

  Widget pills() {
    return ValueListenableBuilder(
        valueListenable: _currentPageNotifier,
        builder: (context, value, child) {
          return Visibility(
            child: new SimpleRoundButton(
              buttonText: Text('Capture Artifacts',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height / 50)),
              backgroundColor: LightColors.kGrey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaptureArtifactsScreen(
                      getPreviousTake: true,
                    ),
                  ),
                );
              },
            ),
            visible: !event_button_vis[value],
            replacement: SizedBox(
              height: 80.0,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height / 1.4);
    double c_width = MediaQuery.of(context).size.width * 0.5;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: LightColors.white,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //SizedBox(height: 10.0),

              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: new EdgeInsets.only(left: 15.0, top: 15.0),
                      child: Image.asset(
                        'assets/pass_photo.jpg',
                        height: MediaQuery.of(context).size.height / 9,
                        width: MediaQuery.of(context).size.height / 9,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 1,
                          color: LightColors.kGrey,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Name : ',
                                          style: TextStyle(
                                              color: LightColors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  55),
                                        ),
                                        Text(
                                          toast['name'] != null
                                              ? toast['name']
                                              : "Unavailable",
                                          style: TextStyle(
                                              color: LightColors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  55),
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Registration No. : ',
                                          style: TextStyle(
                                              color: LightColors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  55),
                                        ),
                                        Text(
                                          toast['registrationNumber'] != null
                                              ? toast['registrationNumber']
                                              : "Unavailable",
                                          style: TextStyle(
                                              color: LightColors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  55),
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    )
                  ]),

              SizedBox(height: 15.0),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Candidate Details',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Card(
                  elevation: 1,
                  color: LightColors.kGrey,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(
                      children: <Widget>[
                        Row(children: [
                          Container(
                            padding: new EdgeInsets.only(left: 10.0, top: 15.0),
                            child: Text(
                              'Venue Name : ',
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 55),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.only(top: 15.0),
                            child: Text(
                              toast['venueName'] != null
                                  ? toast['venueName']
                                  : "Unavailable",
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 55),
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
                                'Batch Timing : ',
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.only(top: 0.0),
                              child: Text(
                                toast['batchTiming'] != null
                                    ? toast['batchTiming']
                                    : "Unavailable",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
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
                              padding:
                                  new EdgeInsets.only(left: 10.0, top: 0.0),
                              child: Text(
                                'ID Proof Details : ',
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.only(top: 0.0),
                              child: Text(
                                toast['iDProof'] != null
                                    ? toast['iDProof']
                                    : "Unavailable",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
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
                              padding:
                                  new EdgeInsets.only(left: 10.0, top: 0.0),
                              child: Text(
                                'Lab Number : ',
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.only(top: 0.0),
                              child: Text(
                                toast['labNo'] != null
                                    ? toast['labNo']
                                    : "Unavailable",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
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
                              padding:
                                  new EdgeInsets.only(left: 10.0, top: 0.0),
                              child: Text(
                                'Father\'s Name : ',
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            50),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.only(top: 00.0),
                              child: Text(
                                toast['fathersName'] != null
                                    ? toast['fathersName']
                                    : "Unavailable",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10.0,
              ),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Personal Details',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 55,
                      fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: 10.0,
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Card(
                  elevation: 1,
                  color: LightColors.kGrey,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 0.0,
                        ),
                        Row(children: <Widget>[
                          Container(
                            padding: new EdgeInsets.only(left: 10.0, top: 00.0),
                            child: Text(
                              'Address : ',
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 55),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            width: c_width,
                            padding: new EdgeInsets.only(top: 15.0),
                            child: Text(
                              toast['communicationAddress'] != null
                                  ? toast['communicationAddress']
                                  : "Unavailable",
                              maxLines: 2,
                              style: TextStyle(
                                  color: LightColors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 55),
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
                                'Contact Number : ',
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.only(top: 0.0),
                              child: Text(
                                toast['contactNumber'] != null
                                    ? toast['contactNumber']
                                    : "Unavailable",
                                style: TextStyle(
                                    color: LightColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              event_tab(),
              SizedBox(height: 15.0),
              page_pills(),
              SizedBox(height: 15.0),
              Center(
                child: _buildCircleIndicator(),
              ),
              pills(),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, String take) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // _buildHeader(),

                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // _toggleDropdown();
                    },
                    child: closeIcon(),
                  ),
                ),

                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
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
                                height:
                                    MediaQuery.of(context).size.height / 2.79,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      alignment: Alignment.center,
                                      child: _candidateImage == null
                                          ? Icon(
                                              Icons.photo_camera,
                                              color: LightColors.grey,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                            )
                                          : Image.file(
                                              _candidateImage,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Candidate\nPhoto",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: LightColors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          45),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          _candidateImage == null
                                              ? notUploadedIcon()
                                              : uploadedIcon(),
                                        ])
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
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
                                height:
                                    MediaQuery.of(context).size.height / 2.79,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      alignment: Alignment.center,
                                      child: _idProof == null
                                          ? Icon(
                                              Icons.file_upload,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4.5,
                                              color: LightColors.grey,
                                            )
                                          : Image.file(_idProof,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6), //color: LightColors.grey,)
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "ID Proof",
                                              style: TextStyle(
                                                  color: LightColors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          45),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          _idProof == null
                                              ? notUploadedIcon()
                                              : uploadedIcon(),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
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
                                height:
                                    MediaQuery.of(context).size.height / 2.79,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.center,
                                        child: _fingerprintImage == null
                                            ? Icon(
                                                Icons.fingerprint,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                                color: LightColors.grey,
                                              )
                                            : Image.asset(
                                                'assets/fingerprint.png',
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                              )),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Biometrics",
                                              style: TextStyle(
                                                  color: LightColors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
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
                                height:
                                    MediaQuery.of(context).size.height / 2.79,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(top: 5.0),
                                        alignment: Alignment.center,
                                        child: _counterfoilImage == null
                                            ? Icon(
                                                Icons.camera_front,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                                color: LightColors.grey,
                                              )
                                            : Image.file(
                                                _counterfoilImage,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                              ) //color: LightColors.grey,)
                                        ),
                                    SizedBox(
                                      height: 17.0,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Counterfoil",
                                              style: TextStyle(
                                                  color: LightColors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          45),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          _counterfoilImage == null
                                              ? notUploadedIcon()
                                              : uploadedIcon(),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 5.0,),
              ],
            ),
          );
        });
  }

  void _getTakePhoto(String take) {
    String empId = prefs.getString("Emp_id"); // scane user Id
    String projectName = prefs.getString("Project_Name");

    Util.getArtifectFileDetailsForUserTake(empId, take, projectName)
        .then((value) {
      setState(() {
        print(empId + take);
        print('setState ${value.length}');
        List<ArtifectFile> list = value;

        if (list != null && list.length > 0) {
          list.forEach((element) {
            switch (element.fileFor) {
              case Util.fileForPhoto:
                _candidateImage = File(element.filePath);
                break;
              case Util.fileForBiometric:
                _fingerprintImage = File(element.filePath);
                break;
              case Util.fileForId:
                _idProof = File(element.filePath);
                break;
              case Util.fileForCounterfoil:
                _counterfoilImage = File(element.filePath);
                break;
            }
          });
        } else // create empty file
        {
          _candidateImage = null;
          _fingerprintImage = null;
          _idProof = null;
          _counterfoilImage = null;
        }
      });
    });
  }

  void _getTotalTake() {
    event_list[0] = List();
    String empId = prefs.getString("Emp_id"); // scane user Id
    String projectName = prefs.getString("Project_Name");
    String key = '$empId$projectName';
    int count = prefs.getInt(key) ?? 0;

    print('Previous Count is $count');

    for (int i = 1; i <= count; i++) {
      event_list[0].add('Take $i');
    }

    setState(() {
      event_list[0];
    });
  }
}
