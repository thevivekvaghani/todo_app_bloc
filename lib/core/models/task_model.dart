import 'package:todo_app/data/enums/task_status.dart';
import 'package:todo_app/core/utils/extensions.dart';

class TaskModel {
  final String id;
  final String name;
  final TaskStatus status;
  final DateTime dueDate;

  TaskModel({
    required this.id,
    required this.name,
    required this.status,
    required this.dueDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"],
    name: json['name'],
    status: json['status'].toString().getTaskStatus(),
    dueDate:  json['due_date'].toDate(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status.name,
    "due_date": dueDate,
  };
}
