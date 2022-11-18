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
  final isolateService = IsolateService();
  final calculatedResult = EntityStateNotifier<int?>();
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.calculate),
        onPressed: () {
          Stopwatch stopWatch = Stopwatch()..start();
          calculatedResult.loading();
          final calculatedValue = isolateService
              .calculate(int.parse(widget.inputTextFieldController.text));
          calculatedValue.then((value) {
            executionTime = stopWatch.elapsed;
            calculatedResult.content(value);
          });
        },
      ),
    );
  }
}
