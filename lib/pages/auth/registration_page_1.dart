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

class RegistrationPage1 extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is EmailVerified) {
          Navigator.pop(context);
          onEmailEntered(emailController.text); // Сохранение email
          pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else if (state is AuthError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: 'Регистрация',
          onPressed: () {
            mainPageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                labelText: 'Эл. почта',
                controller: emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                text: 'Далее',
                onPressed: () {
                  final email = emailController.text;
                  context.read<AuthBloc>().add(VerifyEmailRequested(email));
                },
                single: true,
              ),
              const SizedBox(
                height: 24.0,
              ),
              const TextWithLines(
                text: 'или с помощью',
              ),
              const SizedBox(
                height: 24,
              ),
              RegistrationServicesButton(
                text: 'Apple ID',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              RegistrationServicesButton(
                text: 'Google',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              RegistrationServicesButton(
                text: 'Facebook',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
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
                          mainPageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
