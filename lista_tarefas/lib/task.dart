import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

//https://flutter.dev/docs/development/data-and-backend/json
//https://pub.dev/packages/build_runner

@JsonSerializable()
class Task{
  String title;
  bool isOK;
  Task(this.title,this.isOK);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}