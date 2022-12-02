import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/models/prompts_model.dart';
import 'package:mental_health_app/services/firebase_database_api.dart';

abstract class PromptsRepository {
  Stream<Iterable<Prompt>> getPrompts({required String category});
}

class PromptsRepositoryImp extends PromptsRepository {
  final FirebaseDatabaseApi _fDataSource = getIt();

  @override
  Stream<Iterable<Prompt>> getPrompts({required String category}) {
    return _fDataSource.getPrompts(category: category);
  }

}