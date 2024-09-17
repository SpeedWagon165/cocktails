import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage1 extends StatefulWidget {
  final PageController pageController;
  final PageController mainPageController;
  final Function(String) onEmailEntered;

  const RegistrationPage1({
    super.key,
    required this.pageController,
    required this.mainPageController,
    required this.onEmailEntered,
  });

  @override
  _RegistrationPage1State createState() => _RegistrationPage1State();
}

class _RegistrationPage1State extends State<RegistrationPage1> {
  final emailController = TextEditingController();
  String? emailError; // Для хранения ошибки email

  // Функция для проверки корректности email с использованием регулярного выражения
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _onSubmit(BuildContext context) {
    setState(() {
      emailError = null; // Сброс ошибок
    });

    final email = emailController.text;

    if (email.isEmpty) {
      setState(() {
        emailError = 'Введите электронную почту';
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        emailError = 'Некорректный формат электронной почты';
      });
      return;
    }

    // Отправляем запрос на верификацию email
    context.read<AuthBloc>().add(VerifyEmailRequested(email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          const Center(child: CircularProgressIndicator());
        } else if (state is EmailVerified) {
          widget.onEmailEntered(emailController.text); // Сохранение email
          widget.pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else if (state is AuthError) {
          if (state.message.contains('400')) {
            setState(() {
              emailError = 'Этот email уже зарегистрирован';
            });
          }
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: 'Регистрация',
          onPressed: () {
            widget.mainPageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                labelText: 'Эл. почта',
                controller: emailController,
                errorMessage: emailError, // Отображение ошибки
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Далее',
                onPressed: () {
                  _onSubmit(context); // Валидация и отправка
                },
                single: true,
              ),
              const SizedBox(height: 24.0),
              const TextWithLines(text: 'или с помощью'),
              const SizedBox(height: 24),
              RegistrationServicesButton(text: 'Apple ID', onPressed: () {}),
              const SizedBox(height: 12),
              RegistrationServicesButton(text: 'Google', onPressed: () {}),
              const SizedBox(height: 12),
              RegistrationServicesButton(text: 'Facebook', onPressed: () {}),
              const SizedBox(height: 24.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Уже есть аккаунт? ',
                      style: context.text.bodyText12Grey.copyWith(fontSize: 16),
                    ),
                    TextSpan(
                      text: 'Войти',
                      style: context.text.bodyText16White,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.mainPageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }
}
