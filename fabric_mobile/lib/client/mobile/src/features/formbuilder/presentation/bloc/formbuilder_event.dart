part of 'formbuilder_bloc.dart';

@immutable
abstract class FormbuilderEvent {}

class Getdata extends FormbuilderEvent {
  final String examtype;

  Getdata(this.examtype);

  @override
  List<Object> get props => [examtype];
}
