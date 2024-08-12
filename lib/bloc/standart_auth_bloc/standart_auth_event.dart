part of 'standart_auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String username;
  final String password;

  SignInRequested(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class CheckAuthStatus extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class VerifyEmailRequested extends AuthEvent {
  final String email;

  VerifyEmailRequested(this.email);

  @override
  List<Object> get props => [email];
}

class ConfirmCodeRequested extends AuthEvent {
  final String email;
  final String code;

  ConfirmCodeRequested(this.email, this.code);

  @override
  List<Object> get props => [email, code];
}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final String password;

  RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.password,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        gender,
        dateOfBirth,
        password,
      ];
}
