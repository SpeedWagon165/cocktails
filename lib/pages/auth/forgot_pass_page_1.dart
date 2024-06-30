import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
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
            text: 'Введите электронную почту, куда выслать код подтверждения',
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
              onEmailEntered(emailController.text);
              pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            single: true,
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
