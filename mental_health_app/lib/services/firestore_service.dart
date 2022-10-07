import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/models/user_model.dart';

/*
This class represent all possible CRUD operation for FirebaseFirestore.
It contains all generic implementation needed based on the provided document
path and documentID,since most of the time in FirebaseFirestore design, we will have
documentID and path for any document and collections.
 */
class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> set({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> setAnswer({
    required String uid,
    required String category,
    required String step,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance
      .collection('answers').doc(uid)
      .collection(category).doc(step);
    print('answers/$uid/$category');
    inspect(data);
    await reference.set(data);
  }

//   Future<void> bulkSet({
//     required String path,
//     required List<Map<String, dynamic>> datas,
//     bool merge = false,
//   }) async {
//     final reference = FirebaseFirestore.instance.doc(path);
//     final batchSet = FirebaseFirestore.instance.batch();

// //    for()
// //    batchSet.

//     print('$path: $datas');
//   }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query)?,
    int sort(T lhs, T rhs)?,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<T>> collectionCategoryStream<T>({
    required String category,
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query)?,
    int sort(T lhs, T rhs)?,
  }) {
    Query query = FirebaseFirestore.instance.collection(path).where('category', isEqualTo: category);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<T>> collectionUserAnswerStream<T>({
    required String uid,
    required String category,
    required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query)?,
    int sort(T lhs, T rhs)?,
  }) {
    Query query = FirebaseFirestore.instance.collection('answers').doc(uid).collection(category);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }

  // Stream<UserModel> getUser(String uid) {
  //   var ref = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid);
  //   return ref.snapshots().map(
  //       (val) => UserModel.fromMap(val.data()!, uid));
  // }

Future<UserModel?> getUserModel(String uid) async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(uid);
    final userSnapshot = await docUser.get();
    if (userSnapshot.exists) {
      return UserModel.fromMap(userSnapshot.data()!, uid);
    }
    return null;
  }
}