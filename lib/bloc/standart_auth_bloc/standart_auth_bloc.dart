import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cocktail_auth_response_model.dart';
import '../../provider/cocktail_auth_repository.dart';

part 'standart_auth_event.dart';
part 'standart_auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus); // Add new event handler
    on<SignOutRequested>(_onSignOutRequested);
    on<VerifyEmailRequested>(_onVerifyEmailRequested);
    on<ConfirmCodeRequested>(_onConfirmCodeRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    print('SignInRequested event received');
    emit(AuthLoading());
    print('${event.username} IIIIIIIIIIIIIIIII ${event.password}');
    try {
      final authResponse =
          await authRepository.signIn(event.username, event.password);
      print('Auth response received: ${authResponse.token}');
      emit(AuthAuthenticated(authResponse));
    } catch (e) {
      print('Error during sign-in: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        // Simulate fetching user roles or other data if necessary
        final authResponse = AuthResponse(token: token, roles: []);
        emit(AuthAuthenticated(authResponse));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyEmailRequested(
      VerifyEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.verifyEmail(event.email);
      emit(EmailVerified());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Подтверждение кода
  Future<void> _onConfirmCodeRequested(
      ConfirmCodeRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.confirmCode(event.email, event.code);
      emit(CodeConfirmed());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Регистрация пользователя
  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
        password: event.password,
      );
      emit(UserRegistered());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
