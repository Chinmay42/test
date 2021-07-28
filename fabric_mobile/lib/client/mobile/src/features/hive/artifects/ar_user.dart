import 'package:hive/hive.dart';


part 'ar_user.g.dart';
@HiveType(typeId: 3)
class ArtifectUser extends HiveObject
{
  @HiveField(0)
  String userId;

  ArtifectUser({this.userId});

  @override
  String toString()
  {
    return ' $userId ';
  }

}