import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_monitor/features/3dGraph.dart';
import 'package:habit_monitor/features/2DMap.dart';
import 'package:habit_monitor/models/habitModel.dart';
import 'package:habit_monitor/services/calculateCorr.dart';
import 'package:habit_monitor/services/sqliteToCSVMode.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'database/habitDB.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //print("Covariance is: ${ComputeCorrelation.computeCorrelation2Values()}");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void insert() {
    setState(() {
      HabitDatabase t = HabitDatabase.instance;
      t.insertHabit(HabitEntry(
          title: "title",
          amount: _counter.toDouble(),
          date: DateTime.now(),
          type: "type",
          account: "account",
          category: "category",
          iconCode: 1,
          categoryType: "categoryType"));
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TestGraph();
                  }));
                },
                child: const Text("Cube Test")),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Chart3D();
                  }));
                },
                child: const Text("Graphs")),
            ElevatedButton(
                onPressed: () async {
                  final directory = await getExternalStorageDirectory();
                  final file = File('${directory!.path}/filename.csv');
                  if (!await directory.exists()) {
                    await directory.create(recursive: true);
                  }
                  final csvData =
                      await HabitDatabase.instance.createFullNestedList();
                  final csvString = const ListToCsvConverter()
                      .convert(csvData!.cast<List?>());
                  await file.writeAsString(csvString);
                  print('File created: ${file.path}');
                },
                child: const Text("Create CSV")),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _onShare(context),
                  child: const Text('Share'),
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  FileShare f = FileShare();
                  f.createCSV(name: "test");
                  f.shareFile(context: context, name: "test");
                },
                child: const Text("Test Share")),
            ElevatedButton(
                onPressed: () async {
                  // Share.shareFiles(['${directory.path}/image.jpg'], text: 'Great picture');
                  HabitDatabase t = HabitDatabase.instance;
                  await getExternalStorageDirectory().then(
                      (value) => print("External Storage Directory: $value"));
                },
                child: const Text("path")),
            ElevatedButton(
                onPressed: () {
                  HabitDatabase t = HabitDatabase.instance;
                  t
                      .createFullNestedList()
                      .then((value) => print("List: $value"));
                },
                child: const Text("child")),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: insert,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  _onShare(BuildContext context) async {
    var storageDir = await getExternalStorageDirectory();
    var file = File('${storageDir!.path}/filename.csv');

    try {
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Great picture');
      } else {
        print('File does not exist!');
      }
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
}
