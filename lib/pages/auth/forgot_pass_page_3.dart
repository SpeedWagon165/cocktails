import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage3 extends StatefulWidget {
  final PageController pageController;
  final String email;
  final String code;

  const ForgotPassPage3({
    super.key,
    required this.pageController,
    required this.email,
    required this.code,
  });

  @override
  State<ForgotPassPage3> createState() => _ForgotPassPage3State();
}

class _ForgotPassPage3State extends State<ForgotPassPage3> {
  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool hasNavigated = false;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // Показываем индикатор загрузки, если необходимо
        } else if (state is AuthAuthenticated && !hasNavigated) {
          setState(() {
            hasNavigated = true; // Помечаем, что навигация выполнена
          });
          // Если авторизация успешна, переходим на страницу аккаунта
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CustomBottomNavigationBar(),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: 'Новый пароль',
          onPressed: () {
            widget.pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CenterText(
                text: 'Создайте пароль для вашего аккаунта',
                padding: 60,
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                labelText: 'Новый пароль',
                obscureText: true,
                isJoined: true,
                joinPosition: JoinPosition.top,
                controller: passwordController,
              ),
              CustomTextField(
                labelText: 'Повторите новый пароль',
                obscureText: true,
                isJoined: true,
                joinPosition: JoinPosition.bottom,
                controller: confirmPasswordController,
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                text: 'Войти',
                onPressed: () {
                  final password = passwordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (password == confirmPassword) {
                    print(
                        'Sending ResetPassword event with email: ${widget.email}, code: ${widget.code}');
                    context.read<AuthBloc>().add(
                          ResetPassword(
                            code: widget.code,
                            email: widget.email,
                            newPassword: password,
                            repeatPassword: confirmPassword,
                          ),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Пароли не совпадают")),
                    );
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
  }
}
