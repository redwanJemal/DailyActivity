import 'dart:convert';

import 'package:daily_activity/database/Database.dart';
import 'package:daily_activity/models/Category.dart';
import 'package:daily_activity/models/Task.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TaskService{


  Future<String> _loadDataAsset() async {
    return await rootBundle.loadString('assets/data.json');
  }

  getTasks() async {
    List<TaskModel> tasks;
    String jsonString = await _loadDataAsset();
    final jsonResponse = json.decode(jsonString);
    Iterable list = jsonResponse['tasks'];

    tasks  = list.map((model) => TaskModel.fromJson(model)).toList();
    return tasks;
  }

  getCategories() async {
    List<CategoryModel> tasks;
    String jsonString = await _loadDataAsset();
    final jsonResponse = json.decode(jsonString);
    Iterable list = jsonResponse['categories'];

    tasks  = list.map((model) => CategoryModel.fromJson(model)).toList();
    return tasks;
  }
//
  newTask(TaskModel newTask) async {
//    final db = await DBProvider().database;
//    //get the biggest id in the table
//    await db.rawQuery("SELECT MAX(id)+1 as id FROM Task");
//    //insert to the table using the new id
//    var raw = await db.rawInsert(
//        "INSERT Into Task (title,description,startDate,startTime,endTime,status)"
//            " VALUES (?,?,?,?,?,?)",
//        [newTask.title,newTask.description,newTask.startDate,newTask.startTime,newTask.endTime,newTask.status]);
//    return raw;
  await loginUser();
  }
//
  updateTask(TaskModel newTask) async {
    final db = await DBProvider().database;
    var res = await db.update("Task", newTask.toJson(),
        where: "id = ?", whereArgs: [newTask.id]);
    return res;
  }
//
  getTask(int id) async {
    final db = await DBProvider().database;
    var res = await db.query("Task", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TaskModel.fromJson(res.first) : null;
  }
//
  Future<List<TaskModel>> getAllTasks() async {
    final db = await DBProvider().database;
    var res = await db.query("Task");
    List<TaskModel> list =
    res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }
//
  Future<List<TaskModel>> getAllTodayTasks(String date,currentPage,pageSize) async {
    int limit = pageSize;
    int offset = (currentPage - 1) * pageSize;
    final db = await DBProvider().database;
    var res = await db.query("Task", where: "startDate = ?", whereArgs: [date],limit: limit,offset: offset);
    List<TaskModel> list =
    res.isNotEmpty ? res.map((c) => TaskModel.fromJson(c)).toList() : [];
    return list;
  }
//
  deleteTask(int id) async {
    final db = await DBProvider().database;
    return db.delete("Task", where: "id = ?", whereArgs: [id]);
  }
//
  deleteAll() async {
    final db = await DBProvider().database;
    db.rawDelete("Delete * from Task");
  }
//
  registerUser() async{
    String url = 'https://tranquil-brushlands-32357.herokuapp.com/api/auth/register';
    Map<String, String> headers = {"Content-type": "application/json"};
    var user = jsonEncode({
      "user_name":"redwan",
      "first_name":"Redwan",
      "phone":"+251929408558",
      "last_name":"Jemal",
      "password":"password",
      "email":"redwan.j@yahoo.com",
      "department_id":"1"
    });
    http.Response response = await http.post(url,headers: headers,body: user);
    print(response.statusCode);
  }

  loginUser() async{
    String url = 'https://tranquil-brushlands-32357.herokuapp.com/api/auth/login';
    Map<String, String> headers = {"Content-type": "application/json"};
    var user = jsonEncode({

      "email":"redwan.j@yahoo.com",
      "password":"password"
    });
    http.Response response = await http.post(url,headers: headers,body: user);
    print(response.statusCode);
    print(response.body);
  }
}