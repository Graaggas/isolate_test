import 'package:db_isolate_test/screens/main_model.dart';
import 'package:db_isolate_test/screens/main_screen.dart';
import 'package:db_isolate_test/services/database/database.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';

MainWM createMainWM(BuildContext context) => MainWM(
      model: MainModel(),
    );

class MainWM extends WidgetModel<MainScreen, MainModel> {
  final inputTextFieldController = TextEditingController();
  EntityStateNotifier<int?> get calculatedResult => model.calculatedResult;

  Stream<List<Measure>> get databaseStream => model.databaseStream;

  Duration? get executionTime => model.executionTime;
  TextStyle get customStyle => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
      );

  void onCalculateTap() => model.onCalculateTap(inputTextFieldController.text);

  MainWM({
    required MainModel model,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
  }
}
