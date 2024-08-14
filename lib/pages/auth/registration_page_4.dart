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
          child: Column(
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
              ),
              CustomTextField(
                labelText: 'Повторите пароль',
                obscureText: true,
                controller: confirmPasswordController,
                isJoined: true,
                joinPosition: JoinPosition.bottom,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Зарегистрироваться',
                gradient: true,
                onPressed: () {
                  final password = passwordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (password == confirmPassword) {
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Пароли не совпадают")),
                    );
                  }
                },
                single: true,
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
