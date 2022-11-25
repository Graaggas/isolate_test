import 'dart:async';

import 'package:db_isolate_test/services/database/database.dart';
import 'package:db_isolate_test/services/isolate_service.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final inputTextFieldController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseStreamController = StreamController<List<Measure>>();
  final database = Database();
  final isolateService = IsolateService();
  final calculatedResult = EntityStateNotifier<int?>();

  var initialData = <Measure>[];

  Duration? executionTime = Duration.zero;

  EntityStateNotifier<int?> get result => calculatedResult;

  @override
  void initState() {
    calculatedResult.content(null);
    super.initState();
  }

  @override
  void dispose() {
    calculatedResult.dispose();
    databaseStreamController.close();
    result.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18,
    );
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: widget.inputTextFieldController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Colors.black), //<-- SEE HERE
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          EntityStateNotifierBuilder<int?>(
            listenableEntityState: result,
            loadingBuilder: (_, __) => const CircularProgressIndicator(),
            builder: (_, primes) => primes == null
                ? const Text('Tap on FAB to calculate', style: textStyle)
                : Text(
                    '${primes.toString()} primes - $executionTime',
                    style: textStyle,
                  ),
          ),
          const SizedBox(height: 24),
          StreamBuilder<List<Measure>>(
              initialData: initialData,
              stream: databaseStreamController.stream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) => Text(
                          '${data[index].id}: ${data[index].number}, ${data[index].amount}, ${data[index].timer}'),
                      separatorBuilder: (_, __) => const Text('----'),
                      itemCount: snapshot.data!.length,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Table is empty'),
                  );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.calculate),
        onPressed: () {
          Stopwatch stopWatch = Stopwatch()..start();
          final number = widget.inputTextFieldController.text;
          calculatedResult.loading();
          final calculatedValue = isolateService.calculate(int.parse(number));
          calculatedValue.then((value) async {
            executionTime = stopWatch.elapsed;
            calculatedResult.content(value);

            await database.insertData(
              number: number,
              amount: value.toString(),
              timer: executionTime.toString(),
            );
            final result = await database.getMeasures();
            databaseStreamController.sink.add(result);
          });
        },
      ),
    );
  }

  Future<void> getInitialData() async {
    final initialDataFromDatabase = await database.getMeasures();
    databaseStreamController.sink.add(initialDataFromDatabase);
  }
}
