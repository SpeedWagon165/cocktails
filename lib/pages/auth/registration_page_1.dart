import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage1 extends StatelessWidget {
  final PageController pageController;
  final PageController mainPageController;

  const RegistrationPage1({
    super.key,
    required this.pageController,
    required this.mainPageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Регистрация',
      onPressed: () {
        mainPageController.animateToPage(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomTextField(
            labelText: 'Эл. почта',
          ),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
            text: 'Далее',
            onPressed: () {
              pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Уже есть аккаунт? ',
                  style:
                      context.textStyles.bodyText12Grey.copyWith(fontSize: 16),
                ),
                TextSpan(
                  text: 'Войти',
                  style: context.textStyles.bodyText16White,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate back to Sign In Page
                      mainPageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
