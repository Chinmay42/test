
import 'package:fabric_mobile/client/mobile/injection_container.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/repositories/dashboard_repository.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/presentation/bloc/dashboard_bloc.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/presentation/widgets/dashboard_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../../../../../../injection_container.dart';

class DashboardFormBuilderScreen extends StatefulWidget {
  @override
  _DashboardFormBuilderScreenState createState() => _DashboardFormBuilderScreenState();
}

class _DashboardFormBuilderScreenState extends State<DashboardFormBuilderScreen> {
  DashboardBloc bloc;
  String userid = "1";
  @override
  void initState() {
    super.initState();
    bloc = DashboardBloc(repository: sl<DashboardRepository>());
  }

  @override
  Widget build(BuildContext context) {
    bloc.add(Getdata(userid));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColors.kGrey,
        title: Text(
          "Exam Dashboard",
          style: TextStyle(color: LightColors.grey),
          textAlign: TextAlign.center,
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
          bloc: bloc,
          builder: (BuildContext context, DashboardState dashboardstate) {
            if (dashboardstate is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (dashboardstate is Error) {
              return Text('Ayo! Error');
            } else if (dashboardstate is Loaded) {
              return DashboardList(dashboards: dashboardstate.dashboardItems);
            }
            return Container(
                color: Colors.orangeAccent,
                height: double.infinity,
                width: double.infinity);
          }),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
