
import 'package:shared_preferences/shared_preferences.dart';

class Util
{
  static String myRunningProject = 'Active Projects';
  static String myRunningProjectDescription = 'List of total active projects';

  static String myTotalProject = 'Total Project';
  static String myTotalProjectDescription = 'Total number of projects that are available.';

  static String myBatchTitle = 'Batch Allotment';
  static String myBatchDescription = 'You can view all available batches';

  static String scaneTitle = 'Scan QR code';
  static String scaneDescription = 'Tap to scan user QR code to get candidate detail';

  static String userListTitle = 'Candidate List';
  static String userListDescription = 'You can view all the candidate details, along with Artifacts submitted';

  static String uploadTitle = 'Artifacts Uploadation';
  static String uploadDescription = 'Click here to upload your artifacts';



 static addCoachMark(value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('tutorial_coach_mark', value);

    print(prefs.getBool('tutorial_coach_mark'));
  }


 static Future<bool> getCoachMark() async
 {
   SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('tutorial_coach_mark')?? false;
 }



}