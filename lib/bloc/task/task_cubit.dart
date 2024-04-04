import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/core/models/task_model.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/data/enums/task_status.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState(status: ApiStateStatus.initial));

  Future<void> get() async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final data = FirebaseFirestore.instance.collection("task");
        QuerySnapshot querySnapshot = await data.where('uid', isEqualTo : authData.userId).get();
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        emit(
          state.copyWith(
            status: ApiStateStatus.success,
            response: allData.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList(),
          ),
        );
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

  // Future<void> addTask({
  //   required String name,
  //   required DateTime dueDate,
  // }) async {
  //   try {
  //     emit(state.copyWith(status: ApiStateStatus.loading));
  //     final authData = getLoginResponse;
  //     if (authData != null) {
  //       final a = await FirebaseFirestore.instance.collection('task').add({
  //         "name": name,
  //         "due_date": dueDate,
  //         "status": TaskStatus.pending.name,
  //         "id": "",
  //       });
  //       await FirebaseFirestore.instance.collection('task').doc(a.id).update({
  //         "id": a.id,
  //       });
  //       emit(state.copyWith(
  //         status: ApiStateStatus.success,
  //       ));
  //     } else {
  //       emit(
  //         state.copyWith(
  //           status: ApiStateStatus.error,
  //           error: "User Data not Found.",
  //         ),
  //       );
  //     }
  //   } on FirebaseException catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: ApiStateStatus.error,
  //         error: e.toString(),
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: ApiStateStatus.error,
  //         error: e.toString(),
  //       ),
  //     );
  //   }
  // }
}
