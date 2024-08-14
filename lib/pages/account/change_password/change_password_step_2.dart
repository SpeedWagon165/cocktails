import 'dart:async';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import 'change_password_step_3.dart';

class ChangePasswordStep2 extends StatefulWidget {
  final String email;

  const ChangePasswordStep2({super.key, required this.email});

  @override
  State<ChangePasswordStep2> createState() => ChangePasswordStep2State();
}

class ChangePasswordStep2State extends State<ChangePasswordStep2> {
  Timer? timer;
  int start = 59;
  final codeController = TextEditingController();

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetCodeConfirmed) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangePasswordStep3(
              email: widget.email,
              code: codeController.text,
            ),
          ));
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
              child: Column(
                children: [
                  const CustomArrowBack(
                    text: 'Смена пароля',
                    arrow: true,
                    auth: false,
                    onPressed: null,
                  ),
                  const SizedBox(height: 33),
                  CenterText(
                    text: 'Мы отправили код на почту ${widget.email}',
                    padding: 60,
                    pop: false,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: 'Код',
                    controller: codeController,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'Повторная отправка кода через 00:${start.toString().padLeft(2, '0')}',
                        style: context.text.bodyText16White,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 29),
                  CustomButton(
                    text: 'Подтвердить',
                    onPressed: () {
                      context.read<AuthBloc>().add(ConfirmResetCode(
                            email: widget.email,
                            code: codeController.text,
                          ));
                    },
                    single: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
