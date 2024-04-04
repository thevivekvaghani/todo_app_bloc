import 'package:todo_app/data/enums/api_state_status.dart';

class AuthState {
  final ApiStateStatus status;
  final String? error;

  AuthState({required this.status,this.error});

  AuthState copyWith({
    required ApiStateStatus status,
    String? error
  }) {
    return AuthState(
        status: status,
        error: error
    );
  }
}


