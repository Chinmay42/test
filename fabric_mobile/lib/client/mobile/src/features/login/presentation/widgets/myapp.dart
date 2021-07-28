import 'package:catcher/core/catcher.dart';
import 'package:fabric_mobile/client/mobile/src/features/route_generator/route_generator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {


    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      builder: (BuildContext context, Widget widget) {
        Catcher.addDefaultErrorWidget(
            showStacktrace: true,
            maxWidthForSmallMode: MediaQuery. of(context). size. width);
        return widget;
      },
      initialRoute: '/splash',
      onGenerateRoute: RouteGenerator.generateRoute,


    );
  }


}