import 'dart:async';
import 'dart:io';

import 'package:daily_activity/models/Category.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    print('getting database');
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "DailyActivity.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Category ("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "tasksCount INTEGER,"
              ")");
        });
  }

  newCategory(CategoryModel newCategory) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Category");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Category (id,name,tasksCount)"
            " VALUES (?,?,?)",
        [id, newCategory.name,newCategory.count]);
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