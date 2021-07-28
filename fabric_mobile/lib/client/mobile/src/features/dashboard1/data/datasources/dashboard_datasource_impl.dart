import 'dart:convert';


import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/datasources/dashboard_datasource.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/models/dahboard_model.dart';
import 'package:flutter/services.dart';


class DashboardDataSourceImpl implements DashboardDataSource {
  DashboardDataSourceImpl();

  @override
  Future<List<DashboardItemModel>> getdata(String userid) async {
    final response = await rootBundle.loadString('assets/dashboard.json');
    return DashboardFromJson(json.decode(response));
  }
}
