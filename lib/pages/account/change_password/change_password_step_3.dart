import 'package:flutter/material.dart';

import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';

class ChangePasswordStep3 extends StatefulWidget {
  const ChangePasswordStep3({super.key});

  @override
  State<ChangePasswordStep3> createState() => ChangePasswordStep3State();
}

class ChangePasswordStep3State extends State<ChangePasswordStep3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'Новый пароль',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 33,
            ),
            const CenterText(
              text: 'Создайте пароль для вашего аккаунта',
              padding: 60,
              pop: false,
            ),
            const SizedBox(
              height: 24,
            ),
            const CustomTextField(
              labelText: 'Новый пароль',
              obscureText: true,
              isJoined: true,
              joinPosition: JoinPosition.top,
            ),
            const CustomTextField(
              labelText: 'Повторите новый пароль',
              obscureText: true,
              isJoined: true,
              joinPosition: JoinPosition.bottom,
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
              text: 'Сохранить изменения',
              onPressed: () {},
              single: true,
            ),
          ]),
        ),
      ),
    );
  }
}
