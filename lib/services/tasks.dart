import 'dart:convert';

import 'package:daily_activity/models/Category.dart';
import 'package:daily_activity/models/Task.dart';
import 'package:flutter/services.dart';

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
}