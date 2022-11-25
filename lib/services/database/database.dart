import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text().named('number')();
  TextColumn get amount => text().named('amount')();
  TextColumn get timer => text().named('timer')();
}

@DriftDatabase(tables: [Measures])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.db'));
    return NativeDatabase(file);
  });
}
