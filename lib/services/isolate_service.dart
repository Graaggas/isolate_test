import 'dart:async';
import 'dart:isolate';

import 'package:db_isolate_test/services/calculation_utils.dart';

class IsolateService {
  late ReceivePort receivePort;

  IsolateService();

  Future<int> calculate(int n) async {
    final resultCompleter = Completer<int>();
    resultCompleter.future;

    final receivePort = ReceivePort();
    final dataBundle = {
      'port': receivePort.sendPort,
      'data': n,
    };
    final isolate = await Isolate.spawn(heavyFunction, dataBundle);

    receivePort.listen((message) {
      if (message is int) {
        isolate.kill(priority: Isolate.immediate);
        return resultCompleter.complete(message);
      }
    });

    return resultCompleter.future;
  }
}

void heavyFunction(Map<String, dynamic> map) {
  final SendPort port = map['port'];
  final int n = map['data'];

  final primes = sieveOfEratosthenes(n);

  port.send(primes.length);
}
