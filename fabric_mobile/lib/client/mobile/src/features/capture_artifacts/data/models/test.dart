import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'downloader_util.dart';

const debug = true;

class MyHomePage extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  MyHomePage({Key key, this.title, this.platform}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {





  TaskInfo myTaskInfo;
   String _localPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);



    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, DownloadUtil.portName);
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (myTaskInfo != null) {

        if(myTaskInfo?.taskId==id)
          {
            setState(() {
              myTaskInfo?.status = status;
              myTaskInfo?.progress = progress;
            });

            if(progress==100) _openDownloadedFile(myTaskInfo);
          }

      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(DownloadUtil.portName);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName(DownloadUtil.portName);
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('jnfdsj'),
      ),
      body: Center(
      child: IconButton(
        icon: Icon(Icons.download_done_outlined),
        onPressed: () async =>_requestDownload(myTaskInfo),
      )),
    );
  }







  void _requestDownload(TaskInfo task,) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        fileName: DownloadUtil.fileName,
        showNotification: true,
        openFileFromNotification: true);
  }



  Future<bool> _openDownloadedFile(TaskInfo task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId);
    } else {
      return Future.value(false);
    }
  }




  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();


    myTaskInfo = TaskInfo(name: DownloadUtil.name, link: DownloadUtil.link_url);
    tasks.forEach((task) {

        if (myTaskInfo.link == task.url) {
          myTaskInfo.taskId = task.taskId;
          myTaskInfo.status = task.status;
          myTaskInfo.progress = task.progress;
        }
    });

    await _prepareSaveDir();


  }

  Future<void> _prepareSaveDir() async {
    _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + DownloadUtil.folderName;

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    print('_prepareSaveDir $_localPath');
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}