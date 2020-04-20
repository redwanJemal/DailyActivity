import 'dart:convert';

class TaskModel{
  int id;
  String title;
  String description;
  int status;
  String startDate;
  String startTime;
  String endTime;

  TaskModel({this.id,this.title,this.description,this.status,this.startDate,this.startTime,this.endTime});
  factory TaskModel.fromRawJson(String str) => TaskModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory TaskModel.fromJson(Map<String, dynamic> json) => new TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      endTime: json['endTime']
  );

  Map<String, dynamic> toJson()=>{
    "id":id,
    "title":title,
    "description":description,
    "status":status,
    "startDate":startDate,
    "startTime":startTime,
    "endTime":endTime
  };

}