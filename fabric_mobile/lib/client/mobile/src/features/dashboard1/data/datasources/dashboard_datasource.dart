
//import 'package:oesapp/src/features/dashboard/data/models/dahboard_model.dart';

import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/models/dahboard_model.dart';

abstract class DashboardDataSource {
  Future<List<DashboardItemModel>> getdata(String userid);
}
