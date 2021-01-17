import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreHelperUtil {
  FirestoreHelperUtil._();

  static final instance = FirestoreHelperUtil._();

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs.map((snapshot) => builder(snapshot.data())).where((value) => value != null).toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<List<T>> collection<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = await query.get();
    final result = snapshots.docs.map((snapshot) => builder(snapshot.data())).where((value) => value != null).toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  Stream<List<T>> collectionGroupQueryStream<T>({
    @required String collectionName,
    @required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    var query = FirebaseFirestore.instance.collectionGroup(collectionName);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs.map((snapshot) => builder(snapshot.data())).where((value) => value != null).toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<List<T>> collectionGroupQuery<T>({
    @required String collectionName,
    @required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) async {
    var query = FirebaseFirestore.instance.collectionGroup(collectionName);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = await query.get();
    final result = snapshots.docs.map((snapshot) => builder(snapshot.data())).where((value) => value != null).toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  Future<T> document<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshot = await reference.get();
    return builder(snapshot.data());
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()));
  }
}
