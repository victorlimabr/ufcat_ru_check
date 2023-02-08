import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_dao.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/db/dao.dart';

extension SheetDao on Dao<Sheet> {
  CollectionReference<Entry> get entries => collection.doc(id).entries;
}

extension SheetCollection on CollectionReference<Sheet> {
  Stream<Result<List<Sheet>>> get observe {
    return limit(50).snapshots().map(
      (sheets) => ResultSuccess(
        sheets.docs.map((entry) => entry.data()).toList(),
      ),
    );
  }

  Future<Result<List<Sheet>>> get read async {
    final snapshot = await limit(50).getSavy();
    return ResultSuccess(snapshot.docs.map((e) => e.data()).toList());
  }
}

extension FirestoreDocumentExtension<T> on DocumentReference<T> {
  Future<DocumentSnapshot<T>> getSavy() async {
    try {
      final ds = await get(const GetOptions(source: Source.cache));
      if (!ds.exists) return get(const GetOptions(source: Source.server));
      return ds;
    } catch (_) {
      return get(const GetOptions(source: Source.server));
    }
  }
}

extension FirestoreQueryExtension<T> on Query<T> {
  Future<QuerySnapshot<T>> getSavy() async {
    try {
      final qs = await get(const GetOptions(source: Source.cache));
      if (qs.docs.isEmpty) return get(const GetOptions(source: Source.server));
      return qs;
    } catch (_) {
      return get(const GetOptions(source: Source.server));
    }
  }
}