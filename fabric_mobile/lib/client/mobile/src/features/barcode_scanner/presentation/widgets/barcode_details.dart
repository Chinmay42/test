import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
//import 'package:pdf_flutter/pdf_flutter.dart';
//import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
//import 'package:toast/toast.dart';
//import 'package:pdf/widgets.dart' as pw;

class BarCodeDetailsPage extends StatefulWidget {
  BarCodeDetailsPage(
      {Key key, this.title, context, this.barcodeDetails, this.detail})
      : super(key: key);
  final Map<String, dynamic> barcodeDetails;
  String detail;

  final String title;

  @override
  _BarCodeDetailsPageState createState() =>
      _BarCodeDetailsPageState(barcodeDetails, detail);
}

class _BarCodeDetailsPageState extends State<BarCodeDetailsPage>
    with TickerProviderStateMixin {
  _BarCodeDetailsPageState(Map<String, dynamic> barcodeDetails, String detail) {
    //this.toast=str1;
    this.barcodeDetails1 = barcodeDetails;
    this.detail1 = detail;
  }
  SharedPreferences prefs;
  String detail1;
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  ScrollController _scrollController = new ScrollController();
  Map<String, dynamic> barcodeDetails1;

  @override
  void initState() {
    super.initState();
    //_sharePreference().then((value) {
    // _getTotalTake();
    // });
    /* Toast.show('$detail1', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  */
  }

  // PdfImage logo;
  //PdfImage candidateimage;
  //final pdf = pw.Document();
  DateTime selectedday = DateTime.now();

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                  color: LightColors.grey,
                  fontSize: MediaQuery.of(context).size.height / 55),
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
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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

  void _navigateToPage({String title, Widget child}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: LightColors.grey,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(color: LightColors.grey),
            ),
            backgroundColor: LightColors.kGrey,
            centerTitle: true,
          ),
          body: Center(child: child),
        ),
      ),
    );
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

              Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                  Widget>[
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      barcodeDetails1['Name'] != null
                                          ? barcodeDetails1['Name']
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      barcodeDetails1['Registration Number'] !=
                                              null
                                          ? barcodeDetails1[
                                              'Registration Number']
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
                              barcodeDetails1['Venue Name'] != null
                                  ? barcodeDetails1['Venue Name']
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
                                barcodeDetails1['Batch Timing'] != null
                                    ? barcodeDetails1['Batch Timing']
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
                                barcodeDetails1['ID Proof'] != null
                                    ? barcodeDetails1['ID Proof']
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
                                //toast['Fathers Name'] != null
                                //  ? toast['Fathers Name']
                                "Unavailable",
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

              /* SizedBox(
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
                            // padding: new EdgeInsets.only(top: 15.0),
                            child: Text(
                              // toast['Communication Address'] != null
                              //   ? toast['Communication Address']
                              "Unavailable",
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
                                // toast['Contact Number'] != null
                                //   ? toast['Contact Number']
                                "Unavailable",
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
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  _navigateToPage(
                    title: "Verified Documents",
                    child: Text(''),
                  );
                },
                child: Padding(
                  padding: new EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Verify Documents',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: LightColors.grey,
                          fontSize: MediaQuery.of(context).size.height / 45),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
