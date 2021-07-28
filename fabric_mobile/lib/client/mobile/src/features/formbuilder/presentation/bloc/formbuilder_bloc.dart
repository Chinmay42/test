import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/data/models/formbuilder_model.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/repositories/formbuilder_repository.dart';

import 'package:meta/meta.dart';

//import 'package:oesapp/src/features/formbuilder/domain/repositories/formbuilder_repository.dart';

part 'formbuilder_event.dart';
part 'formbuilder_state.dart';

class FormbuilderBloc extends Bloc<FormbuilderEvent, FormbuilderState> {
  @override
  FormbuilderState get initialState => FormbuilderInitial();

  FormBuilderRepositiry repositiry;

  FormbuilderBloc({@required this.repositiry});

  @override
  Stream<FormbuilderState> mapEventToState(
    FormbuilderEvent event,
  ) async* {
    if (event is Getdata) {
      yield Loading();
      final output = await repositiry.getdata(event.examtype);
      yield* output.fold((failure) async* {
        yield Error("Something worng..");
      }, (data) async* {
        yield Loaded(data);
      });
    }
  }
}
