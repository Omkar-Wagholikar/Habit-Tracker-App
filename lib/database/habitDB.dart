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

    _database = await _initDB('habits.db');
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
CREATE TABLE ${t.tableHabits} (
  ${t.HabitFields.id} $idType,
  ${t.HabitFields.title} $textType,
  ${t.HabitFields.amount} $doubleType,
  ${t.HabitFields.date} $textType,
  ${t.HabitFields.type} $textType,
  ${t.HabitFields.category} $textType,
  ${t.HabitFields.iconCode} $integerType,
  ${t.HabitFields.categoryType} $textType
  )
''');
  }

  Future<void> insertHabit(t.HabitEntry transaction) async {
    final db = await instance.database;
    await db.insert(t.tableHabits, transaction.toJson());
  }

  Future<t.HabitEntry> create(t.HabitEntry transaction) async {
    final db = await instance.database;
    final id = await db.insert(t.tableHabits, transaction.toJson());
    return transaction.copy(id: id);
  }

  Future<List<t.HabitEntry>?> readAllHabits() async {
    final db = await instance.database;

    const orderBy = '${t.HabitFields.date} DESC';
    final map = await db.query(t.tableHabits, orderBy: orderBy);

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
        v.title,
        v.amount,
        v.date,
        v.type,
      ]);
    }
    return list;
  }

  Future<List<t.HabitEntry>?> readExpenseTransactions() async {
    final db = await instance.database;

    const orderBy = '${t.HabitFields.date} DESC';
    final map = await db.query(t.tableHabits,
        orderBy: orderBy,
        where: '${t.HabitFields.type} = ?',
        whereArgs: ['Expense']);

    if (map.isNotEmpty) {
      return map.map((e) => t.HabitEntry.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> datewiseTransactions() async {
    final db = await instance.database;
    List<Map<String, dynamic>> lst = [];

    final d = await db.rawQuery(
        "SELECT DISTINCT ${t.HabitFields.date} FROM ${t.tableHabits} ORDER BY ${t.HabitFields.date} DESC");
    for (int i = 0; i < d.length; i++) {
      final transactions = await db.query(t.tableHabits,
          columns: t.HabitFields.values,
          where: '${t.HabitFields.date} = ?',
          whereArgs: [d[i]['date']]);
      lst.add({
        'date': DateTime.parse(d[i]['date'] as String),
        'transactions': List.generate(transactions.length,
            (index) => t.HabitEntry.fromJson(transactions[index])),
      });
    }
    if (lst.isEmpty) {
      return null;
    }
    return lst;
  }

  Future<List<Map<String, dynamic>>?> categoryWiseTransactions(
      String categoryName, DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    List<Map<String, dynamic>> lst = [];

    final dates = await db.rawQuery(
        "SELECT DISTINCT ${t.HabitFields.date} FROM ${t.tableHabits} ORDER BY ${t.HabitFields.date} DESC");
    for (int i = 0; i < dates.length; i++) {
      final transactions = await db.query(t.tableHabits,
          columns: t.HabitFields.values,
          where: '${t.HabitFields.date} = ?',
          whereArgs: [dates[i]['date']]);

      List tran = [];
      for (var i = 0; i < transactions.length; i++) {
        t.HabitEntry temp = t.HabitEntry.fromJson(transactions[i]);
        if (temp.category == categoryName &&
            ((temp.date.isAfter(startDate) && temp.date.isBefore(endDate)) ||
                temp.date == startDate ||
                temp.date == endDate)) {
          tran.add(temp);
        }
      }
      if (tran.isNotEmpty) {
        lst.add({
          'date': DateTime.parse(dates[i]['date'] as String),
          'transactions': tran,
        });
      }
    }
    if (lst.isEmpty) {
      return null;
    }
    return lst;
  }

  Future<List<Map<String, Object?>>?> findCategorySum() async {
    final db = await instance.database;

    final map = await db.rawQuery(
        "SELECT ${t.HabitFields.category}, SUM (${t.HabitFields.amount}) FROM ${t.tableHabits} WHERE ${t.HabitFields.type} = 'Expense' GROUP BY ${t.HabitFields.category};");
    if (map.isNotEmpty) {
      return map;
    } else {
      return null;
    }
  }

  Future<t.HabitEntry?> readTransaction(int id) async {
    final db = await instance.database;

    final map = await db.query(t.tableHabits,
        columns: t.HabitFields.values,
        where: '${t.HabitFields.id} = ?',
        whereArgs: [id]);

    if (map.isNotEmpty) {
      return t.HabitEntry.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future<int> update(int id, t.HabitEntry transaction) async {
    final db = await instance.database;
    return db.update(
      t.tableHabits,
      transaction.toJson(),
      where: '${t.HabitFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      t.tableHabits,
      where: '${t.HabitFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
