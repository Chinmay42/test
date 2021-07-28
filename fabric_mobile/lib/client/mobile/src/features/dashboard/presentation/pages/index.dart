import 'package:fabric_mobile/client/mobile/src/core/components/tabIcon_data.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/coach_mark/GlobalKeys.dart';
import 'package:fabric_mobile/client/mobile/src/features/coach_mark/MyContiner.dart';
import 'package:fabric_mobile/client/mobile/src/features/coach_mark/Utils_coachmark.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/dashboard.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/exam_details/presentation/pages/exam_detail.dart';
import 'package:fabric_mobile/client/mobile/src/features/upload_status/presentation/widgets/candidate_upload_stats_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../widgets/bottom_navigation_view/bottom_bar_view.dart';

class FabricAppHomeScreen extends StatefulWidget {
  @override
  _FabricAppHomeScreenState createState() => _FabricAppHomeScreenState();
}

class _FabricAppHomeScreenState extends State<FabricAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  SharedPreferences prefs;
  List<TargetFocus> targets = List();

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: LightColors.white,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = DashboardScreen(animationController: animationController);
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

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
            }
            if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ExamDetailScreen(
                    animationController: animationController,
                  );
                });
              });
            }
            if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  List<String> list = prefs.getStringList('user_list');

                  if (list == null) list = [];

                  print('view detail ${list.length}');
                  tabBody = UploadStatsListScreen(
                    animationController: animationController,
                    userList: list,
                  );
                });
              });
            }
            if (index == 4) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  // tabBody =
                  //   UploadStatsListScreen(animationController: animationController,);
                });
              });
            }
          },
        ),
      ],
    );
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: LightColors.kGreen,
        textSkip: "SKIP",
        textStyleSkip: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 45,
            color: LightColors.white),
        paddingFocus: 10,
        opacityShadow: 0.8, finish: () async {
      await prefs.setBool('watchedIntro', true);
      print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () async {
      await prefs.setBool('watchedIntro', true);
      print("skip");
    }, alignSkip: Alignment.bottomLeft)
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 400), () async {
      prefs = await SharedPreferences.getInstance();
      var watchedIntro = prefs.getBool('watchedIntro') ?? false;
      if (!watchedIntro) showTutorial();
    });
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "assign",
      keyTarget: GlobalKeys.keyAssignProject,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: MyContainer(
              title: Util.myRunningProject,
              description: Util.myRunningProjectDescription,
              crossAxisAlignment: CrossAxisAlignment.start,
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "total_project",
      keyTarget: GlobalKeys.keyTotalProject,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: MyContainer(
              title: Util.myTotalProject,
              description: Util.myTotalProjectDescription,
              crossAxisAlignment: CrossAxisAlignment.start,
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));

    targets.add(TargetFocus(
      identify: "banch",
      keyTarget: GlobalKeys.keyExamSloat,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: MyContainer(
              title: Util.myBatchTitle,
              description: Util.myBatchDescription,
              crossAxisAlignment: CrossAxisAlignment.start,
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));

    targets.add(TargetFocus(
      identify: "scanner",
      keyTarget: GlobalKeys.keyScanner,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: MyContainer(
              title: Util.scaneTitle,
              description: Util.scaneDescription,
              crossAxisAlignment: CrossAxisAlignment.start,
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "list",
      keyTarget: GlobalKeys.keyUserList,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: MyContainer(
              title: Util.userListTitle,
              description: Util.userListDescription,
              crossAxisAlignment: CrossAxisAlignment.start,
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }
}
