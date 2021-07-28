part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}



class Getdata extends DashboardEvent {
  final String userid;

  Getdata(this.userid);

  @override
  List<Object> get props => [userid];
}