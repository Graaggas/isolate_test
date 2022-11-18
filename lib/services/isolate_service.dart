import 'dart:async';
import 'dart:isolate';

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
