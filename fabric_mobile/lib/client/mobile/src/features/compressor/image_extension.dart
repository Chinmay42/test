
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
String folderName = 'Fabric';
class ImageExtension
{

  ImageExtension._privateConstructor();



  static final ImageExtension instance = ImageExtension._privateConstructor();

  factory ImageExtension()
  {
    return instance;
  }



  static Future<String> getFileNameWithExtension(File file)async{

    if(await file.exists()){
      return path.basename(file.path);
    }else{
      return null;
    }
  }

  Future<String> createFolder(TargetPlatform platform) async
  {
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();


    final Directory _appDocDirFolder =  Directory('${directory.path}/$folderName/');

    if(await _appDocDirFolder.exists()){ //if folder already exists return path
      return _appDocDirFolder.path;
    }else{//if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }

  }

 // During write operation
  String getAppSpecificExtension(String currentExtension)
  {
    currentExtension = currentExtension.toUpperCase();


    switch(currentExtension)
    {
      case 'PNG':

        return 'fabP';

      case 'JPEG':
        return 'fabJE';

      case 'JPG':
        return 'fabJ';

      case 'BMP':

        return 'fabB';

      case 'GIF':

        return 'fabG';

      case 'WEBP':

        return 'fabW';

      case 'HEIF':

        return 'fabH';

    }

    return 'fabU'; // for un konown file
  }



  // During Read operation

  String getExtension(String currentExtension)
  {

    switch(currentExtension)
    {
      case 'fabP':

        return 'PNG';

      case 'fabJE':
        return 'JPEG';

      case 'fabJ':
        return 'JPG';
      case 'fabB':

        return 'BMP';

      case 'fabG':

        return 'GIF';

      case 'fabW':

        return 'WebP';

      case 'fabH':

        return 'HEIF';

    }

    return 'PNG'; // for un konown file
  }


  //For whole directory extension
   Future<void> reWriteExtensionOfDirectoryPath(String localPath)async
  {

    var directory = Directory(localPath);

    List files = directory.listSync();

    files.forEach((element)
    async {
      String fileNameWithExtension =  await getFileNameWithExtension(element);

      if(fileNameWithExtension!=null && !fileNameWithExtension.contains('fab'))
        {

         String fileName =  path.basenameWithoutExtension(element.path);
          List<String>  extension = fileNameWithExtension.split(fileName+'.');

          element.rename(File(localPath+fileName+'.'+getAppSpecificExtension(extension[1])).path);
        }


    });
  }





}