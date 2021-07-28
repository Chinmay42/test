import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/entities/dashboard_entities.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/repositories/dashboard_repository.dart';

import 'package:meta/meta.dart';


part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  @override
  DashboardState get initialState => DashboardInitial();

  DashboardBloc({@required this.repository});

  DashboardRepository repository;

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is Getdata) {
      yield Loading();
      final output = await repository.getdata(event.userid);
      yield* output.fold((failure) async* {
        yield Error("Something wrong!");
      }, (dataItems) async* {
        yield Loaded(dataItems);
      });
    }
  }
}
