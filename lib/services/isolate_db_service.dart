import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class IsolateDBService {
  const IsolateDBService();

  DatabaseConnection createDriftIsolateAndConnect() {
    return DatabaseConnection.delayed(
      Future.sync(
        () async {
          final isolate = await _createDriftIsolate();
          return await isolate.connect();
        },
      ),
    );
  }

  Future<DriftIsolate> _createDriftIsolate() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'db.sqlite');
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _startBackground,
      _IsolateStartRequest(receivePort.sendPort, path),
    );

    return await receivePort.first as DriftIsolate;
  }

  void _startBackground(_IsolateStartRequest request) {
    final executor = NativeDatabase(File(request.targetPath));
    final driftIsolate = DriftIsolate.inCurrent(
      () => DatabaseConnection(executor),
    );
    request.sendDriftIsolate.send(driftIsolate);
  }
}

class _IsolateStartRequest {
  final SendPort sendDriftIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendDriftIsolate, this.targetPath);
}
