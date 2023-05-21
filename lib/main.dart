import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_monitor/features/Graphs/3dGraph.dart';
import 'package:habit_monitor/features/Graphs/2DMap.dart';
import 'package:habit_monitor/models/habitModel.dart';
import 'package:habit_monitor/services/calculateCorrelation/calculateCorr.dart';
import 'package:habit_monitor/services/SQLtoCSV/sqliteToCSVMode.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workmanager/workmanager.dart';

import 'database/habitDB.dart';
import 'features/Notification/notifications.dart';

void main() async {
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
        habitName: habitName.text,
        activation: double.parse(activation.text),
        date: DateTime.now(),
        type: type.text,
      ));
      _counter++;
    });
  }

  TextEditingController habitName = TextEditingController();
  TextEditingController activation = TextEditingController();
  TextEditingController type = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    ComputeCorrelation c = ComputeCorrelation();
                    print(
                        "Covariance is: ${ComputeCorrelation.computeCorrelation2Values()}");
                    print("Pressed");
                  },
                  child: const Text("Covariance Test")),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TestGraph();
                    }));
                  },
                  child: const Text("Heat Graph")),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
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
                    t.createFullNestedList().then((value) => {
                          for (var i in value!) {print(i)}
                        });
                  },
                  child: const Text("Print Data")),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Habit Name',
                  ),
                  controller: habitName),
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '0.0',
                  ),
                  controller: activation..text = "0.0"),
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type',
                  ),
                  controller: type),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: insert,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () async {
              await NotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.Inbox,
                  actionButtons: [
                    NotificationActionButton(
                      key: 'SHOW_SERVICE_DETAILS',
                      label: 'a1',
                      actionType: ActionType.Default,
                      autoDismissible: false,
                    ),
                    // NotificationActionButton(
                    //   key: 'SHOW_SERVICE_DETAILS',
                    //   label: 'a2',
                    //   actionType: ActionType.Default,
                    //   color: Colors.green,
                    //   icon: 'resource://drawable/res_food',
                    //   autoDismissible: false,
                    // ),
                    // NotificationActionButton(
                    //   key: 'SHOW_SERVICE_DETAILS',
                    //   label: 'a3',
                    //   actionType: ActionType.Default,
                    //   color: Colors.green,
                    //   icon: 'resource://drawable/res_food',
                    //   autoDismissible: false,
                    // ),
                    // NotificationActionButton(
                    //   key: 'SHOW_SERVICE_DETAILS',
                    //   label: 'a4',
                    //   actionType: ActionType.Default,
                    //   color: Colors.green,
                    //   icon: 'resource://drawable/res_food',
                    //   autoDismissible: false,
                    // ),
                    // NotificationActionButton(
                    //   key: 'SHOW_SERVICE_DETAILS',
                    //   label: 'a5',
                    //   actionType: ActionType.Default,
                    //   color: Colors.green,
                    //   icon: 'resource://drawable/res_food',
                    //   autoDismissible: false,
                    // ),
                  ]);
            },
            tooltip: 'Message',
            child: const Icon(Icons.sms),
          ),
        ],
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
