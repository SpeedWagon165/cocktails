import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UserAgreement extends StatefulWidget {
  @override
  _UserAgreementState createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text:
                    'Даю согласие на обработку персональных данных в соответствии с ',
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: 'пользовательским соглашением.',
                    style: TextStyle(
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
      ),
    );
  }
}
