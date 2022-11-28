import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'my_database.g.dart';

class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text().named('number')();
  TextColumn get amount => text().named('amount')();
  TextColumn get timer => text().named('timer')();
}

@DriftDatabase(tables: [Measures])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(NativeDatabase.memory());

  MyDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  Future<void> clearTable() async {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  Future<void> insertData({
    required String number,
    required String amount,
    required String timer,
  }) =>
      into(measures).insert(
        MeasuresCompanion(
          number: Value(number),
          amount: Value(amount),
          timer: Value(timer),
        ),
      );

  Future<List<Measure>> getMeasures() => select(measures).get();
}
