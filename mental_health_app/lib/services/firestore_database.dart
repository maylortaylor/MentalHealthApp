import 'dart:async';

import 'package:mental_health_app/models/answer_model.dart';
import 'package:mental_health_app/models/prompts_model.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/services/firestore_path.dart';

import 'package:mental_health_app/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/*
This is the main class access/call for any UI widgets that require to perform
any CRUD activities operation in FirebaseFirestore database.
This class work hand-in-hand with FirestoreService and FirestorePath.

Notes:
For cases where you need to have a special method such as bulk update specifically
on a field, then is ok to use custom code and write it here. For example,
setAllTodoComplete is require to change all todos item to have the complete status
changed to true.

 */
class FirestoreDatabase {
  // FirestoreDatabase();
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _firestoreService = FirestoreService.instance;

  // //Method to create/update todoModel
  // Future<void> setUser(UserModel user) async => await _firestoreService.set(
  //       path: FirestorePath.user(uid),
  //       data: user.toMap(),
  //     );

  // Stream<UserModel> getUser({required String uid}) =>
  //     _firestoreService.documentStream(
  //       path: FirestorePath.user(uid),
  //       builder: (data, documentId) => UserModel.fromMap(data, uid),
  //     );

  // Future<UserModel?> getUserModel({required String uid}) =>
  //     _firestoreService.getUserModel(uid);

 

  // Future<void> setUserAnswer(AnswerModel answer) async => await _firestoreService.set(
  //       path: FirestorePath.answers(uid),
  //       data: answer.toMap(),
  //     );

   Future<void> setUserAnswerCat(AnswerModel answer, String cat) async => await _firestoreService.setAnswer(
        uid: uid,
        category: cat,
        step: answer.step,
        data: answer.toMap(),
      );

  // Stream<List<AnswerModel>> userAnswersStream({required String uid, required String category}) => _firestoreService.collectionUserAnswerStream(
  //   uid: uid,
  //   category: category,
  //   builder: (data, documentId) => AnswerModel.fromMap(data, documentId),
  // );

  // //Method to delete Prompt entry
  // Future<void> deleteTodo(Prompt todo) async {
  //   await _firestoreService.deleteData(path: FirestorePath.todo(uid, todo.id));
  // }

  //Method to retrieve Prompt object based on the given promptId
  // Stream<Prompt> promptStream({required String promptId}) =>
  //     _firestoreService.documentStream(
  //       path: FirestorePath.prompt(uid),
  //       builder: (data, documentId) => Prompt.fromMap(data, documentId),
  //     );

  //Method to retrieve all prompts item from the same user based on uid
  // Stream<List<Prompt>> promptsStream() => _firestoreService.collectionStream(
  //       path: FirestorePath.prompts(),
  //       builder: (data, documentId) => Prompt.fromMap(data, documentId),
  //     );

  Stream<List<Prompt>> promptsCategoryStream({required String category}) => _firestoreService.collectionCategoryStream(
    category: category,
    path: FirestorePath.prompts(),
    builder: (data, documentId) => Prompt.fromMap(data),
  );

  //   Stream<List<AnswerModel>> userAnswersStream() => _firestoreService.collectionUserAnswerStream(
  //   uid: uid,
  //   category: 'anger',
  //   builder: (data, documentId) => AnswerModel.fromMap(data, documentId),
  // );

//  Stream<AnswerModel> userAnswersStream() =>
//       _firestoreService.documentStream(
//         path: FirestorePath.answers(uid),
//         builder: (data, documentId) => AnswerModel.fromMap(data, documentId),
//       );

  // //Method to mark all todoModel to be complete
  // Future<void> setAllTodoComplete() async {
  //   final batchUpdate = FirebaseFirestore.instance.batch();

  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection(FirestorePath.prompts())
  //       .get();

  //   for (DocumentSnapshot ds in querySnapshot.docs) {
  //     batchUpdate.update(ds.reference, {'complete': true});
  //   }
  //   await batchUpdate.commit();
  // }

  // Future<void> deleteAllTodoWithComplete() async {
  //   final batchDelete = FirebaseFirestore.instance.batch();

  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection(FirestorePath.prompts())
  //       .where('complete', isEqualTo: true)
  //       .get();

  //   for (DocumentSnapshot ds in querySnapshot.docs) {
  //     batchDelete.delete(ds.reference);
  //   }
  //   await batchDelete.commit();
  // }
}