import 'package:db_isolate_test/screens/main_wm.dart';
import 'package:db_isolate_test/services/database/database.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends ElementaryWidget<MainWM> {
  const MainScreen({
    WidgetModelFactory wmFactory = createMainWM,
    Key? key,
  }) : super(wmFactory, key: key);

  @override
  Widget build(MainWM wm) {
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
              controller: wm.inputTextFieldController,
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
          SizedBox(
            height: 60,
            child: Center(
              child: EntityStateNotifierBuilder<int?>(
                listenableEntityState: wm.calculatedResult,
                loadingBuilder: (_, __) => const CupertinoActivityIndicator(),
                builder: (_, primes) => primes == null
                    ? Text('Tap on FAB to calculate', style: wm.customStyle)
                    : Text(
                        '${primes.toString()} primes - ${wm.executionTime}',
                        style: wm.customStyle,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: StreamBuilder<List<Measure>>(
                stream: wm.databaseStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (_, index) => Text(
                              '${data[index].id}: ${data[index].number}, ${data[index].amount}, ${data[index].timer}'),
                          separatorBuilder: (_, __) => const Text('----'),
                          itemCount: snapshot.data!.length,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Table is empty'),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.calculate),
        onPressed: () => wm.onCalculateTap(),
      ),
    );
  }
}
