import 'package:cocktails/pages/auth/popups/forgot_pass_pop_up1.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/auth/custom_registration_button.dart';
import 'package:cocktails/widgets/auth/text_with_line.dart';
import 'package:cocktails/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';

void authPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: const Color(0xFF1C1615),
    builder: (context) {
      return BasePopup(
        text: 'Вход',
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
                    Navigator.of(context).pop();
                    forgotPassPopUp(context);
                  },
                  child: Text(
                    'Забыли пароль?',
                    style: context.textStyles.bodyText12Grey
                        .copyWith(fontSize: 14),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              text: 'Войти',
              onPressed: () {},
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
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Зарегистрироваться',
                  style: context.textStyles.bodyText16White,
                )),
          ],
        ),
      );
    },
  );
}
