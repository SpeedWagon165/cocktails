import 'dart:async';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage2 extends StatefulWidget {
  final PageController pageController;
  final String email;

  const ForgotPassPage2({
    super.key,
    required this.pageController,
    required this.email,
  });

  @override
  State<ForgotPassPage2> createState() => _ForgotPassPage2State();
}

class _ForgotPassPage2State extends State<ForgotPassPage2> {
  Timer? _timer;

  int _start = 59;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Код подтверждения',
      onPressed: () {
        widget.pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CenterText(
            text: 'Мы отправили код на почту ${widget.email}',
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
                'Повторная отправка кода через 00:${_start.toString().padLeft(2, '0')}',
                style: context.text.bodyText16White,
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
              widget.pageController.animateToPage(3,
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
