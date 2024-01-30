import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:whizzy/blocs/dashboard/dashboard_cubit.dart';

import '../blocs/login/login_cubit.dart';
import '../core/api_client.dart';
import '../repository/dashboard_repository.dart';
import '../repository/login_repository.dart';
import '../routes/route_generator.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance.registerLazySingleton<ApiClient>(() => ApiClient());

  getItInstance.registerLazySingleton<RouteGenerator>(() => RouteGenerator());

  getItInstance.registerLazySingleton(() => LoginRepository(getItInstance()));

  getItInstance
      .registerLazySingleton(() => DashboardRepository(getItInstance()));

  getItInstance.registerFactory(() => LoginCubit(
        loginRepository: getItInstance(),
      ));

  getItInstance.registerFactory(() => DashboardCubit(
        dashboardRepository: getItInstance(),
      ));
}
