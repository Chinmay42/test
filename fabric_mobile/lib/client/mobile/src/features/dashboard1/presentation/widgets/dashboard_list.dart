
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/entities/dashboard_entities.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/presentation/widgets/dashboardbox.dart';
import 'package:flutter/material.dart';

class DashboardList extends StatelessWidget {
  List<DashboardItem> dashboards;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (BuildContext context, int index) {
        final dashboard = dashboards[index];
        return createGridItem(dashboard.text, dashboard.scope);
      },
      itemCount: dashboards.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    );
  }

  DashboardList({this.dashboards});
}
