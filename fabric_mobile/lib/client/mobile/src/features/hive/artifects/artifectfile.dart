import 'package:hive/hive.dart';


part 'artifectfile.g.dart';
@HiveType(typeId: 2)
class ArtifectFile extends HiveObject
{
  @HiveField(0)
  String artifectNumber;
  @HiveField(1)
  String file;
  @HiveField(2)
  String filePath;
  @HiveField(3)
  String status;
  @HiveField(4)
  String userId;
   @HiveField(5)
  String fileFor;
  @HiveField(6)
  String projectName;
   @HiveField(7)
  bool biometricHand; //true for letHand, false for rightHand
  @HiveField(8)
  int biometricHandFinger;
 

  ArtifectFile({this.artifectNumber,this.file, this.filePath, this.status,this.userId,this.fileFor,this.projectName,this.biometricHand,this.biometricHandFinger});

  @override
  String toString() {
    return ' $artifectNumber  and $filePath and $status and $userId';
  }

}

