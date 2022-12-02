import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/models/answer_model.dart';
import 'package:mental_health_app/services/firebase_database_api.dart';

abstract class AnswerRepository {
  Future<void> setAnswer({required AnswerModel answer, required String category});
}

class AnswerRepositoryImp extends AnswerRepository {
  final FirebaseDatabaseApi _fDataSource = getIt();

  // @override
  // String newId() {
  //   return _fDataSource.newId();
  // }

  @override
  Future<void> setAnswer({required AnswerModel answer, required String category}) {
    return _fDataSource.setAnswer(uid: 'anon', category: category, step: answer.step, data: answer.toMap());
  }

}