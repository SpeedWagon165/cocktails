import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/auth/user_agreement.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_switcher.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage3 extends StatefulWidget {
  final PageController pageController;

  const RegistrationPage3({
    super.key,
    required this.pageController,
  });

  @override
  State<RegistrationPage3> createState() => _RegistrationPage3State();
}

class _RegistrationPage3State extends State<RegistrationPage3> {
  final TextEditingController _birthdateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Регистрация',
      onPressed: () {
        widget.pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomTextField(
            labelText: 'Имя*',
            isJoined: true,
            joinPosition: JoinPosition.top,
          ),
          const CustomTextField(
            labelText: 'Фамилия',
            isJoined: true,
            joinPosition: JoinPosition.none,
          ),
          const CustomTextField(
            labelText: 'Эл. почта*',
            isJoined: true,
            joinPosition: JoinPosition.none,
          ),
          const CustomTextField(
            labelText: 'Номер телефона',
            isJoined: true,
            phoneNumber: true,
            joinPosition: JoinPosition.none,
          ),
          CustomTextField(
            labelText: 'Дата рождения',
            isJoined: true,
            joinPosition: JoinPosition.none,
            isDate: true,
            controller: _birthdateController,
          ),
          const CustomTextField(
            labelText: 'Номер реферала',
            isJoined: true,
            isReferral: true,
            joinPosition: JoinPosition.bottom,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ваш пол',
              style: context.text.bodyText16White,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const GradientBorderSwitch(),
          const SizedBox(
            height: 24,
          ),
          const UserAgreement(
            text:
                'Даю согласие на обработку персональных данных в соответствии с ',
            clickText: 'пользовательским соглашением.',
          ),
          const SizedBox(
            height: 12,
          ),
          const UserAgreement(
            text: 'Принимаю условия ',
            clickText: 'политики конфиденциальности.',
          ),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
            text: 'Далее',
            onPressed: () {
              widget.pageController.animateToPage(3,
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
