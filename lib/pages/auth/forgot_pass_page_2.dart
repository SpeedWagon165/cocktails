import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/custom_auth_textfield.dart';

class ForgotPassPage2 extends StatelessWidget {
  final PageController pageController;

  const ForgotPassPage2({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Вход',
      onPressed: () {
        pageController.animateToPage(1,
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
