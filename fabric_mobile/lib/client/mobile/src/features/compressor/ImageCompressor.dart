



import 'dart:io';



import 'package:fabric_mobile/client/mobile/src/features/compressor/image_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart' as path;


File previousPath;
int minimumSize = 35840; //iN KB
int compressorPercentage = 85;
int compressorQality = 85;


Future<void> imageCompressor(File croppedFile,Function setImage,String fileName )
async {

  /**
   * Not perform compressor for small size image
   */
  if(croppedFile.lengthSync()<=minimumSize)
    {
      attachImage(croppedFile,setImage,fileName);
      return;
    }
  applyCompressor(croppedFile,setImage,fileName);

}

void applyCompressor(File croppedFile, Function setImage,String fileName)async
{
  previousPath = croppedFile;
  await FlutterNativeImage.compressImage(croppedFile.path, percentage:compressorPercentage,quality: compressorQality
  ).then((value)
  async {
    //remove Previous cropp value
    bool isExist = await previousPath.exists();

     if(isExist)
      {
        previousPath.delete();
      }
     if(value.lengthSync()>minimumSize)
      {
        applyCompressor(value,setImage,fileName);
      }else
        {
          attachImage(value,setImage,fileName);

        }

  });

}


void attachImage(File value,Function setImage,String name) async
{

print(value.path);
  //change compress file location
  var localPath = await ImageExtension.instance.createFolder(TargetPlatform.android);
  String fileName =  path.basenameWithoutExtension(value.path);
  List<String>  extension =  path.basename(value.path).split(fileName+'.');

   //String name = new DateTime.now().millisecond.toString();
  String newPath =localPath+name+'.'+ImageExtension.instance.getAppSpecificExtension(extension[1]);
   try
  {
  File renamePath = await value.rename(File(newPath).path);

  //change Extension
   setImage(renamePath);
  }
  on FileSystemException catch(e)
  {
    print(e);
    File renamePath = await value.copy(File(newPath).path);
    await value.delete();
    setImage(renamePath);
  }


}