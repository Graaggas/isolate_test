import 'dart:async';

import 'package:db_isolate_test/services/database/database.dart';
import 'package:db_isolate_test/services/isolate_service.dart';
import 'package:elementary/elementary.dart';

class MainModel extends ElementaryModel {
  final database = Database();
  final isolateService = IsolateService();

  final _databaseStreamController = StreamController<List<Measure>>();
  final _calculatedResult = EntityStateNotifier<int?>();

  Duration? _executionTime = Duration.zero;

  EntityStateNotifier<int?> get calculatedResult => _calculatedResult;
  Duration? get executionTime => _executionTime;
  Stream<List<Measure>> get databaseStream => _databaseStreamController.stream;

  @override
  void init() async {
    await _onInit();
    super.init();
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
}
