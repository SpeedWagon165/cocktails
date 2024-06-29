import 'package:flutter/cupertino.dart';

import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage4 extends StatelessWidget {
  final PageController pageController;

  const RegistrationPage4({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Пароль',
      onPressed: () {
        pageController.animateToPage(2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CenterText(
            text: 'Создайте пароль для вашего аккаунта',
            padding: 60,
          ),
          const SizedBox(
            height: 24,
          ),
          const CustomTextField(
            labelText: 'Пароль',
            obscureText: true,
            isJoined: true,
            joinPosition: JoinPosition.top,
          ),
          const CustomTextField(
            labelText: 'Повторите пароль',
            obscureText: true,
            isJoined: true,
            joinPosition: JoinPosition.bottom,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
            text: 'Зарегистрироваться',
            gradient: true,
            onPressed: () {
              pageController.animateToPage(4,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            single: true,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
