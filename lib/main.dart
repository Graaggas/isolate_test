import 'dart:isolate';

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
  var outputText = '';

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReceivePort? receivePort;
  Isolate? isolate;
  SendPort? isolateSendPort;

  @override
  void initState() {
    super.initState();

    spawnIsolate();
  }

  static void remoteIsolate(SendPort sendPort) {
    ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);
    isolateReceivePort.listen((message) {
      final parsedNum = int.parse(message);
      final result = sieveOfEratosthenes(parsedNum);
      sendPort.send(result);
    });
  }

  Future spawnIsolate() async {
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(remoteIsolate, receivePort!.sendPort,
        debugName: "remoteIsolate");
  }

  @override
  void dispose() {
    if (isolate != null) {
      isolate!.kill();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          StreamBuilder(
            stream: receivePort,
            initialData: "NoData",
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data is SendPort) {
                isolateSendPort = snapshot.data;
              }
              return Text(
                snapshot.data.toString(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.calculate),
        onPressed: () {
          isolateSendPort?.send(widget.inputTextFieldController.text);
          setState(() {
            widget.outputText = 'listOfPrimes.toString()';
          });
        },
      ),
    );
  }
}

List<int> sieveOfEratosthenes(int n) {
  final primes = List<bool>.filled(n + 1, true);
  for (var i = 2; i * i < n; i++) {
    if (primes[i]) {
      for (var j = i * i; j <= n; j += i) {
        primes[j] = false;
      }
    }
  }
  final res = <int>[];
  for (var i = 2; i <= n; i++) {
    if (primes[i]) {
      res.add(i);
    }
  }

  return res;
}
