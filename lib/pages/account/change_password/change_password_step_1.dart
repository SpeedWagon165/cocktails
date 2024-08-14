import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import 'change_password_step_2.dart';

class ChangePasswordStep1 extends StatefulWidget {
  const ChangePasswordStep1({super.key});

  @override
  State<ChangePasswordStep1> createState() => ChangePasswordStep1State();
}

class ChangePasswordStep1State extends State<ChangePasswordStep1> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PasswordResetRequested) {
          Navigator.pop(context); // Закрываем диалог загрузки
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ChangePasswordStep2(email: emailController.text),
          ));
        } else if (state is AuthError) {
          Navigator.pop(context); // Закрываем диалог загрузки
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
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
                  const CenterText(
                    text:
                        'Введите номер телефона или почту, куда выслать код подтверждения',
                    padding: 60,
                    pop: false,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: 'Эл. почта',
                    controller: emailController,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Отправить',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                          RequestPasswordReset(email: emailController.text));
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
