import 'dart:async';

import 'package:db_isolate_test/services/calculation_utils.dart';
import 'package:db_isolate_test/services/database/my_database.dart';
import 'package:db_isolate_test/services/isolate_db_service.dart';
import 'package:db_isolate_test/services/isolate_service.dart';
import 'package:db_isolate_test/services/prefs_helper.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';

class MainModel extends ElementaryModel {
  late final MyDatabase database;
  final isolateService = IsolateService();
  final dbConnectionInIsolate = const IsolateDBService().createDriftIsolateAndConnect();

  final _databaseStreamController = StreamController<List<Measure>>();
  final _calculatedResult = EntityStateNotifier<int?>();

  final _isFabAvailable = ValueNotifier<bool>(true);

  Duration? _executionTime = Duration.zero;

  EntityStateNotifier<int?> get calculatedResult => _calculatedResult;
  Duration? get executionTime => _executionTime;
  Stream<List<Measure>> get databaseStream => _databaseStreamController.stream;
  ValueListenable<bool> get isFabAvailable => _isFabAvailable;

  final _isolateUseState = ValueNotifier<bool>(false);

  ValueListenable<bool> get isolateUseState => _isolateUseState;

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

  Future<void> changeIsolateToggle(bool value) async {
    await PrefsHelper.saveData(value);

    _isolateUseState.value = value;
  }

  Future<void> onCalculateTap(String number) async {
    Stopwatch stopWatch = Stopwatch()..start();
    _calculatedResult.loading();
    _isFabAvailable.value = false;

    if (_isolateUseState.value) {
      _runInIsolate(number, stopWatch);
    } else {
      final primes = sieveOfEratosthenes(int.parse(number));
      _executionTime = stopWatch.elapsed;
      _calculatedResult.content(primes.length);
      _isFabAvailable.value = true;

      final updatedDatabaseData = await _updateDatabase(
        database: database,
        number: number,
        amount: primes.length.toString(),
      );
      _databaseStreamController.sink.add(updatedDatabaseData);
    }
  }

  void _runInIsolate(String number, Stopwatch stopWatch) {
    final calculatedValue = isolateService.calculate(int.parse(number));
    calculatedValue.then((value) async {
      _executionTime = stopWatch.elapsed;
      _calculatedResult.content(value);
      _isFabAvailable.value = true;

      final updatedDatabaseData = await _updateDatabase(
        database: database,
        number: number,
        amount: value.toString(),
      );
      _databaseStreamController.sink.add(updatedDatabaseData);
    });
  }

  Future<List<Measure>> _updateDatabase({
    required MyDatabase database,
    required String number,
    required String amount,
  }) async {
    await database.insertData(
      number: number,
      amount: amount,
      timer: executionTime.toString(),
    );

    return await database.getMeasures();
  }

  Future<void> _onInit() async {
    final initData = await database.getMeasures();
    _databaseStreamController.sink.add(initData);

    _isolateUseState.value = await PrefsHelper.getData();
  }

  Future<MyDatabase> _getDB() async {
    return MyDatabase.connect(dbConnectionInIsolate);
  }
}
