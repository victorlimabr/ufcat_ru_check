import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_dao.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';

extension EntryDao on Entry {
  DocumentReference<Sheet> get sheetRef =>
      ServiceLocator.get<CollectionReference<Sheet>>().doc(sheetId);
}

extension SheetReference on DocumentReference<Sheet> {
  CollectionReference<Entry> get entries => collection('entry').withConverter(
    fromFirestore: (snap, _) => snap.data()!.toEntry(),
    toFirestore: (entry, _) => entry.toJson(),
  );
}

extension EntryCollection on CollectionReference<Entry> {
  Stream<Result<List<Entry>>> get observe {
    return limit(50).snapshots().map(
      (entries) => ResultSuccess(
        entries.docs.map((entry) => entry.data()).toList(),
      ),
    );
  }

  Future<Result<List<Entry>>> get read async {
    final snapshot = await limit(50).getSavy();
    return ResultSuccess(snapshot.docs.map((e) => e.data()).toList());
  }

  Future<void> addEntries(Iterable<Entry> entries) async {
    final batch = firestore.batch();
    for (var entry in entries) {
      final now = DateTime.now();
      if (await entry.exists) {
        batch.set<Entry>(entry.ref, entry.copyWith(updatedAt: now));
      } else {
        batch.set<Entry>(
            doc(entry.id), entry.copyWith(createdAt: now, updatedAt: now));
      }
    }
    await batch.commit();
  }
}
