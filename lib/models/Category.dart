import 'dart:convert';

class CategoryModel{
  int id;
  String name;
  int count;

  CategoryModel({this.id,this.name,this.count});
  factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory CategoryModel.fromJson(Map<String, dynamic> json) => new CategoryModel(
      id: json['id'],
      name: json['name'],
      count: json['count'],
  );

  Map<String, dynamic> toJson()=>{
    "id":id,
    "name":name,
    "count":count
  };

}