import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/timer_widget.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage2 extends StatefulWidget {
  final PageController pageController;
  final String email;

  const RegistrationPage2({
    super.key,
    required this.pageController,
    required this.email,
  });

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  final codeController = TextEditingController();
  String? codeError; // Переменная для отображения ошибки

  void _onSubmit(BuildContext context) {
    setState(() {
      codeError = null; // Сбрасываем ошибку перед проверкой
    });

    final code = codeController.text;

    if (code.isEmpty) {
      setState(() {
        codeError = 'Введите код подтверждения'; // Если поле пустое
      });
      return;
    }

    // Если код введен, отправляем запрос на проверку
    context.read<AuthBloc>().add(
          ConfirmCodeRequested(widget.email, code),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is CodeConfirmed) {
          Navigator.pop(context); // Закрываем диалог загрузки
          widget.pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else if (state is AuthError) {
          Navigator.pop(context); // Закрываем диалог загрузки
          setState(() {
            codeError =
                'Неверный код подтверждения'; // Ошибка если код неверный
          });
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: 'Код подтверждения',
          onPressed: () {
            widget.pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CenterText(
                text: 'Мы отправили код на почту ${widget.email}',
                padding: 60,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                labelText: 'Код',
                controller: codeController,
                errorMessage: codeError, // Отображаем ошибку
              ),
              const SizedBox(height: 24.0),
              TimerWidget(
                onTimerEnd: () {
                  print('Timer ended');
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Подтвердить',
                onPressed: () {
                  _onSubmit(context); // Проверка и отправка
                },
                single: true,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
