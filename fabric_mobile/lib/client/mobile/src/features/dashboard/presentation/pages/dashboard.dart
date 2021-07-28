import 'package:fabric_mobile/client/mobile/src/core/components/tabIcon_data.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/artifect_capture_detail/ArtifectDetails.dart';
import 'package:fabric_mobile/client/mobile/src/features/center_map/CenterWidget.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/dashboard_body.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_with_qr/invigilatordetails.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/target_focus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  var bottombarindex = 0;
  SharedPreferences prefs;
  List<TargetFocus> targets = List();

  Widget tabBody = Container(
    color: LightColors.white,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  AnimationController animationController;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(
              'Go Back to Profile Screen?',
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
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvigilatorProfileScreen(),
                    ),
                  );*/
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

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height / 20);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBar(context),
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  SingleChildScrollView(
                    //SizedBox(height: 10.0,),
                    child: DashboardBody(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              );
            }
          },
        ),
        backgroundColor: LightColors.white,
      ), // bottomNavigationBar: bottomBar()
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget _appBar(context) {
    return new AppBar(
      backgroundColor: LightColors.kGrey,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Image.asset(
            'assets/pass_photo.jpg',
            height: MediaQuery.of(context).size.height / 30,
            width: MediaQuery.of(context).size.height / 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                'Hi, John Doe',
                style: TextStyle(
                    color: LightColors.grey,
                    fontSize: MediaQuery.of(context).size.height / 45),
              ),
            ),
          )
        ],
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CenterWidget()));
              },
              child: Icon(
                Icons.directions,
                color: LightColors.grey,
                size: MediaQuery.of(context).size.height / 30,
              ),
            )),
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArtifectDetail()),
                );
              },
              child: Icon(Icons.receipt,
                  color: LightColors.grey,
                  size: MediaQuery.of(context).size.height / 30),
            ))
      ],
      elevation: 0,
    );
  }
}
