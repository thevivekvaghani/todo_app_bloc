import 'package:todo_app/core/models/user_profile_model.dart';
import 'package:todo_app/data/enums/api_state_status.dart';

class ProfileState {
  final ApiStateStatus status;
  final String? error;
  final UserProfileModel? response;

  ProfileState({required this.status,this.error,this.response});

  ProfileState copyWith({
    required ApiStateStatus status,
    String? error,
    UserProfileModel? response
  }) {
    return ProfileState(
        status: status,
        error: error,
        response: response
    );
  }
}
