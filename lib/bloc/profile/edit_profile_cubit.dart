import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/profile/edit_profile_state.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileState(status: ApiStateStatus.initial));

  Future<void> updateUserProfile({
    required String name,
    required String address,
    required String city,
    required String pinCode,
    required DateTime dateOfBirth,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final DocumentReference data =
            FirebaseFirestore.instance.collection("user").doc(authData.userId);
        await data.update({
          "name": name,
          "address": address,
          "city": city,
          "pin_code": pinCode,
          'date_of_birth': dateOfBirth,
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


  Future<void> logoutProfile() async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        await firebaseAuth.signOut();
        await setIsLoggedIn(false);
        await removeLoginResponse();
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

  Future<void> deleteUserAccount() async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final authData = getLoginResponse;
      if (authData != null) {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        final user =  firebaseAuth.currentUser;
        await user?.delete();
        final DocumentReference data =
        FirebaseFirestore.instance.collection("user").doc(authData.userId);
        await data.delete();
        await setIsLoggedIn(false);
        await removeLoginResponse();
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
