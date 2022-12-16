import 'package:db_isolate_test/screens/main_wm.dart';
import 'package:db_isolate_test/services/database/my_database.dart';
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: wm.clearTable,
            icon: const Icon(
              Icons.delete_rounded,
            ),
          ),
          const SizedBox(width: 16),
          const Align(
            child: Text('Use isolates: '),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: wm.isolateUseState,
            builder: (_, state, __) => CupertinoSwitch(
              activeColor: Colors.purple,
              trackColor: Colors.grey,
              value: state,
              onChanged: wm.changeIsolateToggle,
            ),
          ),
        ],
      ),
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
                  borderSide: BorderSide(width: 1, color: Colors.black), //<-- SEE HERE
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
          Table(
            border: const TableBorder(
              bottom: BorderSide(
                width: 1,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(4),
            },
            children: const [
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                      child: Text('number'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('primes\namount'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('execution time'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Measure>>(
                stream: wm.databaseStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (_, index) => Table(
                          border: const TableBorder(
                            bottom:
                                BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(4),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(child: Text(data[index].number)),
                                ),
                                TableCell(
                                  child: Center(child: Text(data[index].amount)),
                                ),
                                TableCell(
                                  child: Center(child: Text(data[index].timer)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        itemCount: snapshot.data!.length,
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
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: wm.isFabAvailable,
        builder: (_, isAvailable, __) => isAvailable
            ? FloatingActionButton(
                child: const Icon(Icons.calculate),
                onPressed: () => wm.onCalculateTap(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
