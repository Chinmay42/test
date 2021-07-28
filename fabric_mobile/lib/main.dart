//import 'package:fabric_app/client/mobile/src/core/routes/routes.dart';
import 'dart:io';

import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/file_handler.dart';
import 'package:catcher/mode/page_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:fabric_mobile/client/mobile/src/core/routes/routes.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/artifects/artifectfile.dart';
import 'package:fabric_mobile/client/mobile/src/features/login/presentation/pages/index.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;

import 'package:flutter_downloader/flutter_downloader.dart';



import 'package:flutter_downloader/flutter_downloader.dart';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'client/mobile/src/features/login/presentation/widgets/myapp.dart';



Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  

   //debugDefaultTargetPlatformOverride = TargetPlatform.windows;
   initializeHive();

   catcherConfiguration();




}

Future<void> catcherConfiguration() async {

  //Local Log.text
  Directory externalDir = await getExternalStorageDirectory();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String path = externalDir.path.toString() + "/FabricLog.txt";

  CatcherOptions debugOptions = CatcherOptions(PageReportMode(showStackTrace: true),[FileHandler(File(path))]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(showStackTrace: true),[FileHandler(File(path))]);

  /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  Catcher(new MyApp(),
   debugConfig: debugOptions, 
   releaseConfig: releaseOptions);


}



initializeHive()
{
   getExternalStorageDirectory().then((directory)
   {  
        Hive
       ..init(directory.path)
       ..registerAdapter(ArtifectFileAdapter());
   });
 }