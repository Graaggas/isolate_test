import 'dart:async';

import 'package:db_isolate_test/services/database/my_database.dart';
import 'package:db_isolate_test/services/isolate_db_service.dart';
import 'package:db_isolate_test/services/isolate_service.dart';
import 'package:elementary/elementary.dart';

class MainModel extends ElementaryModel {
  late final MyDatabase database;
  final isolateService = IsolateService();
  final dbConnectionInIsolate =
      const IsolateDBService().createDriftIsolateAndConnect();

  final _databaseStreamController = StreamController<List<Measure>>();
  final _calculatedResult = EntityStateNotifier<int?>();

  Duration? _executionTime = Duration.zero;

  EntityStateNotifier<int?> get calculatedResult => _calculatedResult;
  Duration? get executionTime => _executionTime;
  Stream<List<Measure>> get databaseStream => _databaseStreamController.stream;

  @override
  Future<void> init() async {
    database = await _getDB();
    await _onInit();
    super.init();
  }

  Future<void> clearTable() async {
    await database.clearTable();

    final updatedDatabaseData = await database.getMeasures();
    _databaseStreamController.sink.add(updatedDatabaseData);
  }

  void onCalculateTap(String number) {
    Stopwatch stopWatch = Stopwatch()..start();
    _calculatedResult.loading();
    final calculatedValue = isolateService.calculate(int.parse(number));
    calculatedValue.then((value) async {
      _executionTime = stopWatch.elapsed;
      _calculatedResult.content(value);

      await database.insertData(
        number: number,
        amount: value.toString(),
        timer: executionTime.toString(),
      );
      final updatedDatabaseData = await database.getMeasures();
      _databaseStreamController.sink.add(updatedDatabaseData);
    });
  }

  Future<void> _onInit() async {
    final initData = await database.getMeasures();
    _databaseStreamController.sink.add(initData);
  }

  Future<MyDatabase> _getDB() async {
    // final isolate = await DriftIsolate.spawn(_backgroundConnection);
    // final connection = await isolate.connect();

    return MyDatabase.connect(dbConnectionInIsolate);
  }

  // DatabaseConnection _backgroundConnection() {
  //   final database = NativeDatabase.memory();
  //   return DatabaseConnection(database);
  // }
}
