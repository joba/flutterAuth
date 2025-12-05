import 'dart:async';
import 'package:auth_app/auth/cubit/auth_state.dart';
import 'package:auth_app/auth/repository/auth_repository.dart';
import 'package:auth_app/managers/analytics_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final AnalyticsManager _analyticsManager;
  late final StreamSubscription<User?> _authStateSubscription;

  AuthCubit(this._authRepository, {AnalyticsManager? analyticsManager})
    : _analyticsManager = analyticsManager ?? AnalyticsManager(),
      super(AuthInitial()) {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authRepository.signIn(email: email, password: password);
      _analyticsManager.logEvent(
        name: 'login',
        parameters: {'method': 'email'},
      );
    } catch (e) {
      String errorMessage = 'An error occurred';
      String errorCode = 'unknown';

      if (e is FirebaseAuthException) {
        errorMessage = e.message.toString();
        errorCode = e.code.toString();
      } else if (e is Map<String, dynamic>) {
        errorMessage = e['message']?.toString() ?? 'An error occurred';
        errorCode = e['code']?.toString() ?? 'unknown';
      }

      emit(AuthError(errorMessage, errorCode));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await _analyticsManager.logEvent(name: 'logout');
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _authRepository.signUp(email: email, password: password);
      _analyticsManager.logEvent(
        name: 'sign_up',
        parameters: {'method': 'email'},
      );
    } catch (e) {
      String errorMessage = 'An error occurred';
      String errorCode = 'unknown';

      if (e is FirebaseAuthException) {
        errorMessage = e.message.toString();
        errorCode = e.code.toString();
      } else if (e is Map<String, dynamic>) {
        errorMessage = e['message']?.toString() ?? 'An error occurred';
        errorCode = e['code']?.toString() ?? 'unknown';
      }

      emit(AuthError(errorMessage, errorCode));
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
