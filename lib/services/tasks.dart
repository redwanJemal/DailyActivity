import 'dart:convert';

import 'package:daily_activity/models/Task.dart';
import 'package:flutter/services.dart';

class TaskService{


  Future<String> _loadTasksAsset() async {
    return await rootBundle.loadString('assets/tasks.json');
  }

  getTasks() async {
    List<TaskModel> tasks;
    String jsonString = await _loadTasksAsset();
    final jsonResponse = json.decode(jsonString);
    Iterable list = jsonResponse['tasks'];

    tasks  = list.map((model) => TaskModel.fromJson(model)).toList();
    return tasks;
  }
}