import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/auth/auth_state.dart';
import 'package:todo_app/core/models/auth_data_model.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(status: ApiStateStatus.initial));

  Future<void> signUp({
    required String name,
    required String email,
    required String address,
    required String city,
    required String pinCode,
    required String password,
    required DateTime dateOfBirth,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user != null) {
        final DocumentReference data =
            FirebaseFirestore.instance.collection("user").doc(user.user!.uid);
        await data.set({
          "uid": user.user!.uid,
          "name": name,
          "email": email,
          "address": address,
          "city": city,
          "pin_code": pinCode,
          'password': password,
          'date_of_birth': dateOfBirth,
        });
        await setIsLoggedIn(true);
        await setLoginResponse(
          AuthDataModel(
            name: name,
            email: email,
            userId: user.user!.uid,
          ),
        );
        emit(state.copyWith(
          status: ApiStateStatus.success,
        ));
      } else {
        emit(
          state.copyWith(
            status: ApiStateStatus.error,
            error: "Internal Server Error.",
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: "Your credential is incorrect",
            ),
          );
          break;

        case "null":
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: "Some unexpected error while trying to sign in",
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: e.toString(),
            ),
          );
      }
    } finally {
      emit(state.copyWith(status: ApiStateStatus.initial));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: ApiStateStatus.loading));
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user != null) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.user!.uid)
            .get();
        if (snap.exists) {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(user.user!.uid)
              .get()
              .then((DocumentSnapshot snapshot) => {
                    setIsLoggedIn(true),
                    setLoginResponse(AuthDataModel(
                        userId: user.user!.uid,
                        email: snapshot['email'],
                        name: snapshot['name'])),
                  });
        } else {
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: "User Data not found.",
            ),
          );
        }

        emit(state.copyWith(
          status: ApiStateStatus.success,
        ));
      } else {
        emit(
          state.copyWith(
            status: ApiStateStatus.error,
            error: "Internal Server Error.",
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: "Your credential is incorrect",
            ),
          );
          break;

        case "null":
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: "Some unexpected error while trying to sign in",
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              status: ApiStateStatus.error,
              error: e.toString(),
            ),
          );
      }
    } finally {
      emit(state.copyWith(status: ApiStateStatus.initial));
    }
  }
}
