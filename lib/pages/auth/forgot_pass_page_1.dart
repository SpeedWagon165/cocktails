import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                text: 'Отправить',
                onPressed: () {
                  final email = emailController.text;
                  context
                      .read<AuthBloc>()
                      .add(RequestPasswordReset(email: email));
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
