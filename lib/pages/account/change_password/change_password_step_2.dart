import 'dart:async';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import 'change_password_step_3.dart';

class ChangePasswordStep2 extends StatefulWidget {
  final String email;

  const ChangePasswordStep2({super.key, required this.email});

  @override
  State<ChangePasswordStep2> createState() => ChangePasswordStep2State();
}

class ChangePasswordStep2State extends State<ChangePasswordStep2> {
  Timer? timer;

  int start = 59;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'Смена пароля',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 33,
            ),
            CenterText(
              text: 'Мы отправили код на почту ${widget.email}',
              padding: 60,
              pop: false,
            ),
            const SizedBox(
              height: 24,
            ),
            CustomTextField(
              labelText: 'Код',
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Повторная отправка кода через 00:${start.toString().padLeft(2, '0')}',
                  style: context.text.bodyText16White,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 29,
            ),
            CustomButton(
              text: 'Подтвердить',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangePasswordStep3()));
              },
              single: true,
            ),
          ]),
        ),
      ),
    );
  }
}
