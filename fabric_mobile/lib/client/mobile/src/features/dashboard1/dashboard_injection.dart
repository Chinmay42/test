





 

import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/datasources/dashboard_datasource.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/datasources/dashboard_datasource_impl.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/repositories/dashboard_repository_impl.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/repositories/dashboard_repository.dart';
import 'package:get_it/get_it.dart';

import 'presentation/bloc/dashboard_bloc.dart';

void DashboardInjection(GetIt sl ) {


  sl.registerFactory(
        () => DashboardBloc(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl( 
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<DashboardDataSource>(
        () => DashboardDataSourceImpl(),
  );
}