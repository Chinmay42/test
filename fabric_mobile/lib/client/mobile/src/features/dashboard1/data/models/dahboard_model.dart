
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/entities/dashboard_entities.dart';
import 'package:flutter/material.dart';
//import 'package:oesapp/src/features/dashboard/domain/entities/dashboard_entities.dart';

List<DashboardItemModel> DashboardFromJson(List<dynamic> jsonItem) =>
    List<DashboardItemModel>.from(
        jsonItem.map((x) => DashboardItemModel.fromJson(x)));

// List DashboardToJson(List<DashboardItemModel> Dashboard) {
//   List jsonItems = List();
//   Dashboard.map((item) => jsonItems.add(item.toJson())).toList();
//   return jsonItems;
// }

class DashboardItemModel extends DashboardItem {
  DashboardItemModel({@required String text, @required String scope})
      : super(
          text: text,
          scope: scope,
        );

  factory DashboardItemModel.fromJson(Map<String, dynamic> json) {
    return DashboardItemModel(text: json['text'], scope: json['scope']);
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'scope': scope};
  }
}
