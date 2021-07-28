
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class UserDetail extends HiveObject
{
  @HiveField(0)
  String userId;
  @HiveField(1)
  String userName;
  @HiveField(2)
  String userMobileNumber;
  @HiveField(3)
  String otherDetails;

  UserDetail({this.userId,this.userName,this.userMobileNumber,this.otherDetails});

  @override
  String toString() {
    // TODO: implement toString
    return '$userId $userName $userMobileNumber $otherDetails';
  }

}