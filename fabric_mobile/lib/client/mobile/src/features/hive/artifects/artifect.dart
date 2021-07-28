

import 'package:hive/hive.dart';

import 'artifectfile.dart';
part 'artifect.g.dart';

@HiveType(typeId: 0)
class Artifect extends HiveObject
{

  @HiveField(0)
  String userId;

  @HiveField(1)
  List<ArtifectFile> artifectList;


  Artifect({this.userId,this.artifectList});

  @override
  String toString() {
    // TODO: implement toString
    return ' $userId  and $artifectList';
  }
}
