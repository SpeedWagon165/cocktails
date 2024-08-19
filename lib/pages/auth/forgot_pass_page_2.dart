import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/timer_widget.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage2 extends StatefulWidget {
  final PageController pageController;
  final String email;
  final Function(String) onCodeEntered;

  const ForgotPassPage2({
    super.key,
    required this.pageController,
    required this.email,
    required this.onCodeEntered,
  });

  @override
  State<ForgotPassPage2> createState() => _ForgotPassPage2State();
}

class _ForgotPassPage2State extends State<ForgotPassPage2> {
  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          print('Loading state triggered');
          const Center(child: CircularProgressIndicator());
        } else if (state is PasswordResetCodeConfirmed) {
          print('PasswordResetCodeConfirmed state triggered');
          widget.onCodeEntered(codeController.text);
          widget.pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else if (state is AuthError) {
          print('AuthError state triggered: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                labelText: 'Код',
                controller: codeController,
              ),
              const SizedBox(
                height: 24.0,
              ),
              TimerWidget(
                onTimerEnd: () {
                  print('Timer ended');
                },
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                text: 'Подтвердить',
                onPressed: () {
                  final code = codeController.text;
                  print('Code entered: $code');
                  context.read<AuthBloc>().add(
                        ConfirmResetCode(email: widget.email, code: code),
                      );
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
