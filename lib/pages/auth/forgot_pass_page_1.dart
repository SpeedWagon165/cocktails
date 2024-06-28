import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage1 extends StatelessWidget {
  final PageController pageController;

  const ForgotPassPage1({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Вход',
      onPressed: () {
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomTextField(
            labelText: 'Электронная почта',
            isJoined: true,
            joinPosition: JoinPosition.top,
          ),
          const CustomTextField(
            labelText: 'Пароль',
            obscureText: true,
            isJoined: true,
            joinPosition: JoinPosition.bottom,
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
              pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Зарегистрироваться',
                style: context.textStyles.bodyText16White,
              )),
        ],
      ),
    );
  }
}
