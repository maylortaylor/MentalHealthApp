import 'package:get_it/get_it.dart';
import 'package:mental_health_app/services/answers_repo.dart';
import 'package:mental_health_app/services/firebase_database_api.dart';
import 'package:mental_health_app/services/navigation_service.dart';
import 'package:mental_health_app/services/prompts_repo.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseDatabaseApi());
  
  locator.registerLazySingleton<AnswerRepository>(() => AnswerRepositoryImp());
  locator.registerLazySingleton<PromptsRepository>(() => PromptsRepositoryImp());
}