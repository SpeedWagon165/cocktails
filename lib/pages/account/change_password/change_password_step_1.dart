import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'Смена пароля',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 33,
            ),
            const CenterText(
              text:
                  'Введите номер телефона или почту, куда выслать код подтверждения',
              padding: 60,
              pop: false,
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangePasswordStep2(
                          email: emailController.text,
                        )));
              },
              single: true,
            ),
          ]),
        ),
      ),
    );
  }
}
