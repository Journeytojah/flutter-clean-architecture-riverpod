// auth_notifier.dart

import 'package:flutter_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_project/features/authentication/presentation/providers/state/auth_state.dart';
import 'package:flutter_project/services/user_cache_service/domain/repositories/user_cache_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/shared/domain/models/models.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthenticationRepository authRepository;
  final UserRepository userRepository;

  AuthNotifier({
    required this.authRepository,
    required this.userRepository,
  }) : super(const AuthState.initial());

  Future<void> loginUser(String username, String password) async {
    state = const AuthState.loading();
    final result = await authRepository.loginUser(
        user: User(username: username, password: password));
    result.fold(
      (exception) => state = AuthState.failure(exception),
      (user) {
        state = const AuthState.success();
        userRepository.saveUser(user: user);
      },
    );
  }

  Future<void> registerUser(String username, String password) async {
    state = const AuthState.loading();
    final result = await authRepository.registerUser(
        user: User(username: username, password: password));
    result.fold(
      (exception) => state = AuthState.failure(exception),
      (user) {
        state = const AuthState.success();
        userRepository.saveUser(user: user);
      },
    );
  }
}
