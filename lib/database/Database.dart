import 'dart:async';
import 'dart:io';

import 'package:daily_activity/models/Category.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  DBProvider._();

  DBProvider();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    print('getting database');
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE Category(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, '
        'tasksCount INTEGER)');

    await db.execute('CREATE TABLE Task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, startDate TEXT,'
        'startDate Text,endDate Text,status INTEGER)');
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "DailyActivityv3.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Category(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, '
              'tasksCount INTEGER)');

          await db.execute('CREATE TABLE Task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, startDate TEXT,'
              'startTime Text,endTime Text,status INTEGER)');
        });
  }

  newCategory(CategoryModel newCategory) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Category (name,tasksCount)"
            " VALUES (?,?)",
        [ newCategory.name,newCategory.count]);
    return raw;
  }

  updateCategory(CategoryModel newCategory) async {
    final db = await database;
    var res = await db.update("Category", newCategory.toJson(),
        where: "id = ?", whereArgs: [newCategory.id]);
    return res;
  }

  getCategory(int id) async {
    final db = await database;
    var res = await db.query("Category", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? CategoryModel.fromJson(res.first) : null;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await database;
    var res = await db.query("Category");
    List<CategoryModel> list =
    res.isNotEmpty ? res.map((c) => CategoryModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Category", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Category");
  }
}