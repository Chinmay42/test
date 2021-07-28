
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/presentation/bloc/formbuilder_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/formbuilder_datasource_impl.dart';
import 'data/datasources/frombuilder_datasource.dart';
import 'data/repositories/formbuilder_repository_impl.dart';
import 'domain/repositories/formbuilder_repository.dart';

void FormBuilderinjection(GetIt sl) {
  // Bloc
  sl.registerFactory(() => FormbuilderBloc(
        repositiry: sl(),
      ));
// Repository
  sl.registerLazySingleton<FormBuilderRepositiry>(
      () => FromBuilderRepositoryImpl(
            fromBuilderDatasource: sl(),
          ));

  // DataSource
  sl.registerLazySingleton<FromBuilderDatasource>(
    () => FromBuilderDatasourceimpl(),
  );
}
