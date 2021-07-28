//import 'package:fabric_app/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/pages/index.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes() {

   runApp(
    new MaterialApp(
      title: "Fabric App",
      debugShowCheckedModeBanner: false,
     // home: new LoginScreen(),
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MaterialPageRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );
            break;

          case '/home':
            return new MaterialPageRoute(
              builder: (_) => new FabricAppHomeScreen(),
              settings: settings,
            );
            break;

          case '/profile':
            return new MaterialPageRoute(
              builder: (_) => ProfileScreen(),
              settings: settings,
            );  
            break;
        }
      },
   ));
  }
}

/*class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}*/
