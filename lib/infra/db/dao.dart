import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufcat_ru_check/data/entity.dart';

abstract class Dao<T extends Entity<T>> {
  final CollectionReference<T> collection;

  Dao(this.collection);

  Future<bool> exists(String id) => collection.exists(id);

  DocumentReference<T> reference(String id) => collection.doc(id);

  Future<T?> reload(String id) => collection.reload(id);

  Future<void> save(T entity, {WriteBatch? batch}) async {
    if (batch != null) return _saveToBatch(entity, batch);
    final now = DateTime.now();
    if (await exists(entity.id)) {
      return collection.save(entity.id, entity.updated(at: now));
    }
    return collection.save(entity.id, entity.created(at: now));
  }

  Future<void> saveAll(Iterable<T> entities, {WriteBatch? batch}) async {
    final bat = batch ?? collection.firestore.batch();
    for (var employee in entities) {
      bat.set(reference(employee.id), employee);
    }
    if (batch == null) await bat.commit();
  }

  Future<void> _saveToBatch(T entity, WriteBatch batch) async {
    final now = DateTime.now();
    if (await exists(entity.id)) {
      return batch.set(reference(entity.id), entity.updated(at: now));
    }
    return batch.set(reference(entity.id), entity.created(at: now));
  }

  Future<T?> find(String id) {
    return collection.find(id);
  }

  Future<List<T>> findAll() async {
    final snaps = await query.get();
    return snaps.docs.map((e) => e.data()).toList();
  }

  Query<T> get query => collection;

  Future<void> delete(String id) {
    return reference(id).delete();
  }
}

extension DocumentReferenceExtensions<T> on DocumentReference<T> {
  Future<bool> get exists async {
    final snap = await get();
    return snap.exists;
  }
}

extension QueryExtension<T extends Entity<T>> on Query<T> {
  Future<List<T>> get entities async {
    final snaps = await get();
    return snaps.docs.map((e) => e.data()).toList();
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
    return doc(id).exists;
  }

  Future<T?> reload(String id) async {
    final snapshot = await doc(id).get();
    return snapshot.data();
  }
}
