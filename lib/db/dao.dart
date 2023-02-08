import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';

mixin Dao<T> on Entity<T> {
  CollectionReference<T> get collection =>
      ServiceLocator.get<CollectionReference<T>>();

  Future<bool> get exists => collection.exists(id);

  DocumentReference<T> get ref => collection.doc(id);

  Future<T?> get reload => collection.reload(id);

  Future<void> save() async {
    final now = DateTime.now();
    if (await exists) {
      return collection.save(id, updated(at: now));
    }
    return collection.save(id, created(at: now));
  }
}

extension DaoHelper<T> on CollectionReference<T> {
  Future<void> save(String id, T entity) async {
    return doc(id).set(entity);
  }

  Future<T?> find(String id) async {
    final snap = await doc(id).get();
    return snap.data();
  }

  Future<bool> exists(String id) async {
    final snap = await doc(id).get();
    return snap.exists;
  }

  Future<T?> reload(String id) async {
    final snapshot = await doc(id).get();
    return snapshot.data();
  }
}
