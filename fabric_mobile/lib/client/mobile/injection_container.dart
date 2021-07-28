import 'package:fabric_mobile/client/mobile/src/features/dashboard1/dashboard_injection.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/formbuilder_injection.dart';
import 'package:get_it/get_it.dart';
//import 'package:oesapp/src/features/dashboard/dashboard_injection.dart';
//import 'package:oesapp/src/features/formbuilder/formbuilder_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Dashboard
  DashboardInjection(sl);

  // ! FormBuilder
  FormBuilderinjection(sl);

  //! Core
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton<HttpClient>(() => HttpClientImpl(client: sl()));
  // sl.registerLazySingleton(() => DataConnectionChecker());
}
