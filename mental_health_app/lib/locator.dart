import 'package:get_it/get_it.dart';
import 'package:mental_health_app/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  // locator.registerLazySingleton(() => Api());
}