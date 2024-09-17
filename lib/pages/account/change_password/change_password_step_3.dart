import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';

class ChangePasswordStep3 extends StatefulWidget {
  final String email;
  final String code;

  const ChangePasswordStep3({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ChangePasswordStep3> createState() => ChangePasswordStep3State();
}

class ChangePasswordStep3State extends State<ChangePasswordStep3> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? passwordError;
  String? confirmPasswordError;
  String? generalError;

  bool hasNavigated = false;

  void _onSubmit(BuildContext context) {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
      generalError = null;
    });

    final password = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    bool isValid = true;

    if (password.isEmpty || password.length < 8) {
      setState(() {
        passwordError = 'Пароль должен содержать минимум 8 символов';
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = 'Повторите пароль';
      });
      isValid = false;
    }

    if (password != confirmPassword) {
      setState(() {
        generalError = 'Пароли не совпадают';
        isValid = false;
      });
    }

    if (isValid) {
      context.read<AuthBloc>().add(
            ResetPassword(
              code: widget.code,
              email: widget.email,
              newPassword: password,
              repeatPassword: confirmPassword,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess && !hasNavigated) {
          setState(() {
            hasNavigated = true;
          });

          // После успешной смены пароля проверяем авторизацию
          context.read<AuthBloc>().add(CheckAuthStatus());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пароль изменен')),
          );
          int count = 0;
          Navigator.of(context).popUntil((route) {
            return count++ == 2;
          });
        } else if (state is AuthError) {
          setState(() {
            generalError = state.message;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
              child: Column(
                children: [
                  const CustomArrowBack(
                    text: 'Новый пароль',
                    arrow: true,
                    auth: false,
                    onPressed: null,
                  ),
                  const SizedBox(height: 33),
                  const CenterText(
                    text: 'Создайте пароль для вашего аккаунта',
                    padding: 60,
                    pop: false,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: 'Новый пароль',
                    obscureText: true,
                    isJoined: true,
                    joinPosition: JoinPosition.top,
                    controller: newPasswordController,
                    errorMessage: passwordError,
                    showRedBorder: generalError != null,
                  ),
                  CustomTextField(
                    labelText: 'Повторите новый пароль',
                    obscureText: true,
                    isJoined: true,
                    joinPosition: JoinPosition.bottom,
                    controller: confirmPasswordController,
                    errorMessage: confirmPasswordError,
                    showRedBorder: generalError != null,
                  ),
                  if (generalError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        generalError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12.0),
                      ),
                    ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Сохранить изменения',
                    onPressed: () => _onSubmit(context),
                    single: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
