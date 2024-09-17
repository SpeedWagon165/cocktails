import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../utilities/data_formater.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage1 extends StatelessWidget {
  final PageController pageController;
  final PageController mainPageController;
  final Function(String) onEmailEntered;

  const ForgotPassPage1({
    super.key,
    required this.pageController,
    required this.mainPageController,
    required this.onEmailEntered,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    String? errorMessage;

    bool _isEmailValid(String email) {
      // Простая проверка на корректность email
      final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      return emailRegExp.hasMatch(email);
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              const Center(child: CircularProgressIndicator());
            } else if (state is PasswordResetRequested) {
              onEmailEntered(emailController.text); // Сохранение email
              pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            } else if (state is AuthError) {
              setState(() {
                errorMessage = formatErrorMessage(state.message);
              });
            }
          },
          builder: (context, state) {
            return BasePopup(
              text: 'Забыли пароль?',
              onPressed: () {
                mainPageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CenterText(
                    text:
                        'Введите электронную почту, куда выслать код подтверждения',
                    padding: 60,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    labelText: 'Эл. почта',
                    controller: emailController,
                    errorMessage: errorMessage, // Отображение ошибки
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    text: 'Отправить',
                    onPressed: () {
                      final email = emailController.text.trim();

                      // Проверка на пустое поле и корректность email
                      if (email.isEmpty) {
                        setState(() {
                          errorMessage = 'Введите электронную почту';
                        });
                      } else if (!_isEmailValid(email)) {
                        setState(() {
                          errorMessage = 'Некорректный формат email';
                        });
                      } else {
                        setState(() {
                          errorMessage = null; // Сброс ошибок
                        });

                        context
                            .read<AuthBloc>()
                            .add(RequestPasswordReset(email: email));
                      }
                    },
                    single: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
