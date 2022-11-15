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
  var outputText = '11';

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.outputText.isEmpty
                  ? 'Enter number to calculate'
                  : 'Prime numbers: ${widget.outputText}',
              maxLines: 10,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.calculate),
        onPressed: () {
          sieveOfEratosthenes(int.parse(widget.inputTextFieldController.text));
          setState(() {
            final listOfPrimes = sieveOfEratosthenes(
                int.parse(widget.inputTextFieldController.text));
            widget.outputText = listOfPrimes.toString();
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
