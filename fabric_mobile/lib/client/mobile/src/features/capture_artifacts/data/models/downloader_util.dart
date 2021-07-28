import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadUtil {
  static const String name = 'Bio Metric App';
  static const String link_url =
      'http://59.165.234.14:8796/owncloud/index.php/s/aN5X9mIQ4T3LN0m/download';
  static const String fileName = 'MorphoBiometric.apk';
  static const String portName = 'downloader_send_port';
  static const String folderName = 'download';
}

class TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  TaskInfo({this.name, this.link});
}
