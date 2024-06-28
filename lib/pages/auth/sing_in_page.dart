import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/custom_button.dart';

class SingInPage extends StatelessWidget {
  final PageController pageController;

  const SingInPage({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Вход',
      onPressed: () {
        Navigator.of(context).pop();
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Text(
                  'Забыли пароль?',
                  style:
                      context.textStyles.bodyText12Grey.copyWith(fontSize: 14),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            text: 'Войти',
            onPressed: () {
              Navigator.of(context).pop();
            },
            single: true,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const TextWithLines(
            text: 'или с помощью',
          ),
          const SizedBox(
            height: 24,
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
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextButton(
              onPressed: () {
                pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
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
