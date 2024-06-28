import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage2 extends StatelessWidget {
  final PageController pageController;

  const RegistrationPage2({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Код подтверждения',
      onPressed: () {
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CenterText(
            text: 'Мы отправили код на почту irina_ivanov@gmail.com',
            padding: 60,
          ),
          const SizedBox(
            height: 24,
          ),
          const CustomTextField(
            labelText: 'Код',
          ),
          const SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'Повторная отправка кода через 00:59',
                style: context.textStyles.bodyText16White,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
            text: 'Подтвердить',
            onPressed: () {
              pageController.animateToPage(3,
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
