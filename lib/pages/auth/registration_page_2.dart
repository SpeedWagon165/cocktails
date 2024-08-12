import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage2 extends StatelessWidget {
  final PageController pageController;
  final String email;

  const RegistrationPage2({
    super.key,
    required this.pageController,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();

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
          Navigator.pop(context);
          pageController.animateToPage(2,
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
          text: 'Код подтверждения',
          onPressed: () {
            pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CenterText(
                text: 'Мы отправили код на почту $email',
                padding: 60,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                labelText: 'Код',
                controller: codeController,
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Повторная отправка кода через 00:59',
                    style: context.text.bodyText16White,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Подтвердить',
                onPressed: () {
                  final code = codeController.text;
                  context.read<AuthBloc>().add(
                        ConfirmCodeRequested(email, code),
                      );
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
