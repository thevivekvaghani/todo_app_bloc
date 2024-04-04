import 'package:todo_app/core/models/task_model.dart';
import 'package:todo_app/core/models/user_profile_model.dart';
import 'package:todo_app/data/enums/api_state_status.dart';

class TaskState {
  final ApiStateStatus status;
  final String? error;
  final List<TaskModel>? response;

  TaskState({required this.status,this.error,this.response});

  TaskState copyWith({
    required ApiStateStatus status,
    String? error,
    List<TaskModel>? response
  }) {
    return TaskState(
        status: status,
        error: error,
        response: response
    );
  }
}
