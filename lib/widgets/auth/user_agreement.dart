import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../custom_checkbox.dart';

class UserAgreement extends StatefulWidget {
  final String text;
  final String clickText;
  final Function(bool)
      onCheckChanged; // Колбэк для обработки изменений состояния

  const UserAgreement({
    super.key,
    required this.text,
    required this.clickText,
    required this.onCheckChanged, // Передаем функцию для управления состоянием чекбокса
  });

  @override
  UserAgreementState createState() => UserAgreementState();
}

class UserAgreementState extends State<UserAgreement> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
              widget.onCheckChanged(
                  isChecked); // Сообщаем родительскому компоненту об изменении состояния
            });
          },
          child: CustomCircularCheckbox(
            isChecked: isChecked, // Передаем текущее состояние
            onChanged: (checked) {
              setState(() {
                isChecked = checked;
                widget.onCheckChanged(isChecked);
              });
            },
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: widget.text,
              style: context.text.bodyText12Grey.copyWith(
                fontSize: 13,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: widget.clickText,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Действие при нажатии на пользовательское соглашение
                      print('Пользовательское соглашение нажато');
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
