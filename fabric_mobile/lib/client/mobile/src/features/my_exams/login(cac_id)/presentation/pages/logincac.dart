
import 'package:fabric_mobile/client/mobile/src/core/components/tabIcon_data.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/dashboard.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/bottom_navigation_view/bottom_bar_view.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/exam_details/presentation/pages/exam_detail.dart';
import 'package:fabric_mobile/client/mobile/src/features/upload_status/presentation/widgets/candidate_upload_stats_list.dart';
import 'package:flutter/material.dart';

import 'index.dart';

class LoginCacScreen extends StatefulWidget {
  const LoginCacScreen({Key key,this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _LoginCacScreenState createState() => _LoginCacScreenState();
}

class _LoginCacScreenState extends State<LoginCacScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: LightColors.white,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = SignInScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LightColors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      //DashboardScreen(animationController: animationController);
                   DashboardScreen(animationController: animationController);
                });
              });
            }  if (index == 1 ) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      ExamDetailScreen(animationController: animationController,);
                });
              });
            }
             if (index == 3 ) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                     UploadStatsListScreen(animationController: animationController,);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
