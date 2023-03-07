import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/infra/db/dao.dart';

class EntryRepository extends Dao<Entry> {
  EntryRepository(super.collection);

  Stream<List<Entry>> get observe => collection.snapshots().map(
        (entries) => entries.docs.map((entry) => entry.data()).toList(),
      );
}
