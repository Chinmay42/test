part of 'formbuilder_bloc.dart';

@immutable
abstract class FormbuilderState {}

class FormbuilderInitial extends FormbuilderState {}

class Loading extends FormbuilderState {}

class Loaded extends FormbuilderState {
  final List<FormBuilderModel> fromdata;
  Loaded(this.fromdata);
}

class Error extends FormbuilderState {
  final String message;
  Error(this.message);
}
