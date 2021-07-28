part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class Loading extends DashboardState {}

class Loaded extends DashboardState {
  final List<DashboardItem> dashboardItems;
  Loaded(this.dashboardItems);
}

class Error extends DashboardState {
  final String message;
  Error(this.message);
}
