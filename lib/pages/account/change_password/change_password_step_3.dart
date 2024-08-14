import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';

class ChangePasswordStep3 extends StatefulWidget {
  final String email;
  final String code;

  const ChangePasswordStep3(
      {super.key, required this.email, required this.code});

  @override
  State<ChangePasswordStep3> createState() => ChangePasswordStep3State();
}

class ChangePasswordStep3State extends State<ChangePasswordStep3> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is PasswordResetSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароль изменен')),
        );
        int count = 0;
        Navigator.of(context).popUntil((route) {
          return count++ == 2;
        });
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }, builder: (context, state) {
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
                  text: 'Новый пароль',
                  arrow: true,
                  auth: false,
                  onPressed: null,
                ),
                const SizedBox(height: 33),
                const CenterText(
                  text: 'Создайте пароль для вашего аккаунта',
                  padding: 60,
                  pop: false,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  labelText: 'Новый пароль',
                  obscureText: true,
                  isJoined: true,
                  joinPosition: JoinPosition.top,
                  controller: newPasswordController,
                ),
                CustomTextField(
                  labelText: 'Повторите новый пароль',
                  obscureText: true,
                  isJoined: true,
                  joinPosition: JoinPosition.bottom,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Сохранить изменения',
                  onPressed: () {
                    context.read<AuthBloc>().add(ResetPassword(
                          email: widget.email,
                          newPassword: newPasswordController.text,
                          repeatPassword: confirmPasswordController.text,
                          code: widget.code,
                        ));
                  },
                  single: true,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
