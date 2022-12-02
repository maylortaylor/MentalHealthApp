import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/models/prompts_model.dart';

class FirebaseDatabaseApi{
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  late CollectionReference refPrompts;
  late CollectionReference refAnswers;

  FirebaseDatabaseApi() {
    refPrompts = firestore.collection('prompts');
    refAnswers = firestore.collection('answers');
  }

  Stream<Iterable<Prompt>> getPrompts({required String category}) {
    return firestore
        .collection('prompts')
        .where('category', isEqualTo: category)
        .snapshots().map(
          (snapshot) => snapshot.docs
            .map((doc) => Prompt.fromMap(doc.data())).toList()
        );
  }

  Future<void> setAnswer({
    required String uid,
    required String category,
    required String step,
    required Map<String, dynamic> data
  }) async {
    final reference = FirebaseFirestore.instance
      .collection('answers').doc(uid)
      .collection(category).doc(step);
    print('answers/$uid/$category');
    inspect(data);
    await reference.set(data);
  }

  Stream<QuerySnapshot> streamPromptsDataCollection() {
    return refPrompts.snapshots() ;
  }

  Stream<QuerySnapshot> streamAnswersDataCollection() {
    return refAnswers.snapshots() ;
  }
  
}