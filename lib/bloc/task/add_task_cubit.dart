import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/data/enums/task_status.dart';

class AddTaskCubit extends Cubit<TaskState> {
  AddTaskCubit() : super(TaskState(status: ApiStateStatus.initial));


  Future<void> addTask({
    required String name,
    required DateTime dueDate,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final a = await FirebaseFirestore.instance.collection('task').add({
          "name": name,
          "due_date": dueDate,
          "status": TaskStatus.pending.name,
          "uid": authData.userId,
          "id": "",
        });
        await FirebaseFirestore.instance.collection('task').doc(a.id).update({
          "id": a.id,
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

  Future<void> deleteTask({
    required String id,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        await FirebaseFirestore.instance.collection('task').doc(id).delete();
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

  Future<void> updateStatus({
    required String id,
    required TaskStatus status,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        await FirebaseFirestore.instance.collection('task').doc(id).update(
          {
            "status": status.name,
          }
        );
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