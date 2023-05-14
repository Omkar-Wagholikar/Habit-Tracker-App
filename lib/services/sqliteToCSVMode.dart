import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';

import '../database/habitDB.dart';

class FileShare {
  Future<void> createCSV({required String name}) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$name.csv');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final csvData = await HabitDatabase.instance.createFullNestedList();
    final csvString =
        const ListToCsvConverter().convert(csvData!.cast<List?>());
    await file.writeAsString(csvString);
    print('File created: ${file.path}');
  }

  Future<void> shareFile(
      {required BuildContext context, required String name}) async {
    var storageDir = await getExternalStorageDirectory();
    var file = File('${storageDir!.path}/$name.csv');
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
