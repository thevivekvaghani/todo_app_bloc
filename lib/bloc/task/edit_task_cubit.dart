import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/data/enums/task_status.dart';

class EditTaskCubit extends Cubit<TaskState> {
  EditTaskCubit() : super(TaskState(status: ApiStateStatus.initial));


  Future<void> editTask({
    required String id,
    required String name,
    required DateTime dueDate,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final DocumentReference data =
        FirebaseFirestore.instance.collection("task").doc(id);
        await data.update({
          "name": name,
          "due_date": dueDate,
        });
        emit(state.copyWith(
          status: ApiStateStatus.success,
        ));
      } else {
        emit(
          state.copyWith(
            status: ApiStateStatus.error,
            error: "User Data not Found.",
          ),
        );
      }
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          status: ApiStateStatus.error,
          error: e.toString(),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ApiStateStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

}