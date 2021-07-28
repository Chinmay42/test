
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/inviligator_creation/inviligator_index.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/inviligator_login/presentation/pages/login_option.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/presentation/pages/index.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/pages/qr_scan.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/widgets/qr_details.dart';
import 'package:fabric_mobile/client/mobile/src/features/splash_screen/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../capture_artifacts/presentation/widgets/capture_artifacts.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => FabricAppHomeScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/loginoption':
        return MaterialPageRoute(builder: (_) => LoginOptions());
      case '/inviligatorcreate':
        return MaterialPageRoute(builder: (_) => InviligatorCreateScreen());
      case '/captureartifacts':
        return MaterialPageRoute(builder: (_) => CaptureArtifactsScreen());    




      default:
      // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: SizedBox(height: 0)));
    }
  }
}

