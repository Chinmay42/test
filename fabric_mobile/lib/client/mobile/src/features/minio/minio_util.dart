import 'dart:io';
import 'package:fabric_mobile/client/mobile/src/features/hive/Util.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/artifects/artifectfile.dart';
import 'package:fabric_mobile/client/mobile/src/features/thumb_selection/entity/finger_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:minio/minio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiniOUtil {
  SharedPreferences prefs;
  MiniOUtil._privateConstructor();

  static final MiniOUtil _instance = MiniOUtil._privateConstructor();

  factory MiniOUtil() {
    return _instance;
  }

  final minio = Minio(
    endPoint: '59.165.234.9',
    port: 1005,
    useSSL: false,
    accessKey: 'aaa',
    secretKey: 'deadbeef',
  );

  final String bucketName = "fabric";

  void checkCreateBucket() async {
    minio.bucketExists(bucketName).then((bool value) {
      if (!value) {
        minio.makeBucket(bucketName);
      }
    });
  }

  Future<bool> uploadFile(
      List<File> fileList, FingerSelector fingerSelector) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String projectName =
        prefs.getString("Project_Name") ?? "Tango1"; //your select Project
    String empId = prefs.getString("Emp_id") ?? "00001"; // scane user Id
    String takeNumber = prefs.getString("TakeNo") ?? "1"; // your initiated take
    bool anyError = false;
    if (fileList != null && fileList.length > 0) {
      fileList.forEach((File file) async {
        if (file != null) {
          int len = file.lengthSync();
          Stream<List<int>> inputStream = file.openRead();
          String objectName = projectName +
              "/" +
              empId +
              "/" +
              takeNumber +
              "/" +
              path.basename(file.path);
          await minio.putObject(bucketName, objectName, inputStream, len).then(
              (value) {
            print(value);
          }, onError: (e) {
            anyError = true;
            print(e.toString());
          });
        }
      });
    }

    if (!anyError) {
      String key = '$empId$projectName';
      int count = prefs.getInt(key) ?? 0;
      prefs.setInt(key, count + 1);

      saveFileMinio(fileList, fingerSelector);
    }
  }

  saveFileMinio(List<File> files, FingerSelector fingerSelector) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ArtifectFile> myList = List();

    for (int i = 0; i < files.length; i++) {
      String fileFor;
      switch (i) {
        case 0:
          fileFor = Util.fileForPhoto;
          break;
        case 1:
          fileFor = Util.fileForBiometric;
          break;
        case 2:
          fileFor = Util.fileForId;
          break;
        case 3:
          fileFor = Util.fileForCounterfoil;
          break;
      }

      ArtifectFile artifectFile = ArtifectFile(
          artifectNumber: "${prefs.getString("TakeNo")}",
          file: files[i].path,
          filePath: files[i].path,
          status: 'None',
          userId: '${prefs.getString("Emp_id")}',
          fileFor: fileFor,
          biometricHandFinger:fingerSelector.select_finger,
          biometricHand: fingerSelector.isLeftHand,
          projectName: "${prefs.getString("Project_Name")}");

      myList.add(artifectFile);
    }

    Util.storeArtifectFileDetails('${prefs.getString("Emp_id")}', myList);
  }
}
