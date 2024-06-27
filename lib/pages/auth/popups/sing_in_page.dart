import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/auth/custom_registration_button.dart';
import '../../../widgets/auth/text_with_line.dart';
import '../../../widgets/custom_button.dart';
import 'auth_pop_up.dart';
import 'forgot_pass_pop_up1.dart';

import 'package:flutter/material.dart';

class MainAuthNavigator extends StatelessWidget {
  const MainAuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const SingInPage();
            break;
          case '/registration':
            builder = (BuildContext context) => RegistrationNavigator();
            break;
          case '/forgotPassword':
            builder = (BuildContext context) => ForgotPasswordNavigator();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class SingInPage extends StatelessWidget {
  const SingInPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  style:
                      context.textStyles.bodyText12Grey.copyWith(fontSize: 14),
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
  }
}
