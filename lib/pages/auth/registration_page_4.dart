import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage4 extends StatelessWidget {
  final PageController pageController;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String dateOfBirth;

  const RegistrationPage4({
    super.key,
    required this.pageController,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // Переменные для хранения ошибок
    String? passwordError;
    String? confirmPasswordError;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BasePopup(
          text: 'Пароль',
          onPressed: () {
            pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CenterText(
                    text: 'Создайте пароль для вашего аккаунта',
                    padding: 60,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: 'Пароль',
                    obscureText: true,
                    controller: passwordController,
                    isJoined: true,
                    joinPosition: JoinPosition.top,
                    errorMessage: passwordError, // Ошибка для пароля
                  ),
                  CustomTextField(
                    labelText: 'Повторите пароль',
                    obscureText: true,
                    controller: confirmPasswordController,
                    isJoined: true,
                    joinPosition: JoinPosition.bottom,
                    errorMessage:
                        confirmPasswordError, // Ошибка для подтверждения пароля
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Зарегистрироваться',
                    gradient: true,
                    onPressed: () {
                      final password = passwordController.text;
                      final confirmPassword = confirmPasswordController.text;

                      // Сброс ошибок перед валидацией
                      setState(() {
                        passwordError = null;
                        confirmPasswordError = null;
                      });

                      // Проверка пароля
                      if (password.isEmpty) {
                        setState(() {
                          passwordError = 'Введите пароль';
                        });
                      } else if (password.length < 8) {
                        setState(() {
                          passwordError =
                              'Пароль должен содержать не менее 8 символов';
                        });
                      }

                      // Проверка подтверждения пароля
                      if (confirmPassword.isEmpty) {
                        setState(() {
                          confirmPasswordError = 'Введите подтверждение пароля';
                        });
                      } else if (password != confirmPassword) {
                        setState(() {
                          confirmPasswordError = 'Пароли не совпадают';
                        });
                      }

                      // Если ошибок нет, регистрируем пользователя
                      if (passwordError == null &&
                          confirmPasswordError == null) {
                        context.read<AuthBloc>().add(
                              RegisterRequested(
                                firstName: firstName,
                                lastName: lastName,
                                phone: phone,
                                gender: gender,
                                dateOfBirth: dateOfBirth,
                                password: password,
                                email: email,
                              ),
                            );
                        pageController.animateToPage(4,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    single: true,
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
