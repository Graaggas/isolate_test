import 'dart:isolate';

import 'package:flutter/foundation.dart';

class IsolateService {
  late ReceivePort receivePort;

  IsolateService();

  Future<void> calculate(int n) async {
    final receivePort = ReceivePort();
    final dataBundle = {
      'port': receivePort.sendPort,
      'data': n,
    };
    await Isolate.spawn(heavyFunction, dataBundle);

    receivePort.listen((message) {
      if (message is List<int>) {
        debugPrint('==> $message');
      }
    });
  }
}

void heavyFunction(Map<String, dynamic> map) {
  final SendPort port = map['port'];
  final int n = map['data'];

  final primes = sieveOfEratosthenes(n);

  port.send(primes);
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
