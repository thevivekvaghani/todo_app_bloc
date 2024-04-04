import 'package:todo_app/data/enums/api_state_status.dart';

class EditProfileState {
  final ApiStateStatus status;
  final String? error;

  EditProfileState({required this.status,this.error,});

  EditProfileState copyWith({
    required ApiStateStatus status,
    String? error,
  }) {
    return EditProfileState(
        status: status,
        error: error,
    );
  }
}