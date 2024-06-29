import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
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
  int _selectedIndex = 0;

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
          const CustomTextField(
            labelText: 'Дата рождения',
            isJoined: true,
            joinPosition: JoinPosition.none,
          ),
          const CustomTextField(
            labelText: 'Номер реферала',
            isJoined: true,
            joinPosition: JoinPosition.bottom,
          ),
          const SizedBox(
            height: 20.0,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: 1,
            cornerRadius: 10.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: ['Male', 'Female'],
            activeBgColors: [
              [Colors.blue],
              [Colors.pink],
            ],
            onToggle: (index) {
              _selectedIndex = index!;
            },
          ),
        ],
      ),
    );
  }
}
