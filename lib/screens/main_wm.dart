import 'package:db_isolate_test/screens/main_model.dart';
import 'package:db_isolate_test/screens/main_screen.dart';
import 'package:db_isolate_test/services/database/my_database.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

MainWM createMainWM(BuildContext context) => MainWM(
      model: MainModel(),
    );

class MainWM extends WidgetModel<MainScreen, MainModel> {
  final inputTextFieldController = TextEditingController();
  EntityStateNotifier<int?> get calculatedResult => model.calculatedResult;

  Stream<List<Measure>> get databaseStream => model.databaseStream;

  ValueListenable<bool> get isolateUseState => model.isolateUseState;

  Duration? get executionTime => model.executionTime;
  TextStyle get customStyle => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
      );

  Future<void> changeIsolateToggle(bool value) =>
      model.changeIsolateToggle(value);

  void clearTable() => model.clearTable();

  void onCalculateTap() {
    final text = inputTextFieldController.text;

    if (text.isNotEmpty) {
      model.onCalculateTap(inputTextFieldController.text);
    } else {
      calculatedResult.content(0);
    }
  }

  MainWM({
    required MainModel model,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
  }
}
