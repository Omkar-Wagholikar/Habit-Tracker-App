import 'dart:ffi';
import 'package:scidart/numdart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/habitModel.dart' as t;
import '../models/habitModel.dart';

class HabitDatabase {
  static final HabitDatabase instance = HabitDatabase._init();

  static Database? _database;

  HabitDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
CREATE TABLE ${t.tableTransactions} (
  ${t.HabitFields.id} $idType,
  ${t.HabitFields.habitName} $textType,
  ${t.HabitFields.activation} $doubleType,
  ${t.HabitFields.date} $textType,
  ${t.HabitFields.type} $textType
)
''');
  }

  Future<void> insertHabit(t.HabitEntry transaction) async {
    final db = await instance.database;
    await db.insert(t.tableTransactions, transaction.toJson());
  }

  Future<t.HabitEntry> create(t.HabitEntry transaction) async {
    final db = await instance.database;
    final id = await db.insert(t.tableTransactions, transaction.toJson());
    return transaction.copy(id: id);
  }

  Future<List<t.HabitEntry>?> readAllHabits() async {
    final db = await instance.database;

    const orderBy = '${t.HabitFields.date} DESC';
    final map = await db.query(t.tableTransactions, orderBy: orderBy);

    if (map.isNotEmpty) {
      return map.map((e) => t.HabitEntry.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> createFullNestedList() async {
    HabitDatabase t = HabitDatabase.instance;
    List<dynamic> list = [];
    List<HabitEntry>? habits = await t.readAllHabits();
    for (var v in habits!) {
      list.add([
        v.habitName,
        v.activation,
        v.date,
        v.type,
      ]);
    }
    return list;
  }

  Future<void> getColumnNames() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> columns =
        await db.rawQuery('PRAGMA table_info(${t.tableTransactions})');

    final List<String> columnNames =
        columns.map((column) => column['name'] as String).toList();

    print(columnNames);
  }

  Future<List<dynamic>> habitwiseTransactions(
      {required String column, required List<String> search}) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> rows = await db.query(
        '${t.tableTransactions}',
        where: '$column = ?',
        whereArgs: search);
    return rows;
  }

  Future<List<String>> getUniqueColumnValues(String columnName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT DISTINCT $columnName FROM ${t.tableTransactions}');

    final List<String> uniqueValues =
        result.map((row) => row[columnName].toString()).toList();

    return uniqueValues;
  }

  Future<int> update(int id, t.HabitEntry transaction) async {
    final db = await instance.database;
    return db.update(
      t.tableTransactions,
      transaction.toJson(),
      where: '${t.HabitFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      t.tableTransactions,
      where: '${t.HabitFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future deleteAllValues() async {
    final db = await instance.database;
    db.delete(t.tableTransactions);
  }
}
