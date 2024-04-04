import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/profile/profile_state.dart';
import 'package:todo_app/core/models/user_profile_model.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState(status: ApiStateStatus.initial));

  Future<void> get() async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final data = await FirebaseFirestore.instance
            .collection("user")
            .doc(authData.userId)
            .get();
        if (data.exists) {
          emit(
            state.copyWith(
              status: ApiStateStatus.success,
              response: UserProfileModel.fromJson(data.data()!),
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
