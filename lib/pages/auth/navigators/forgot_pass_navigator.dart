import 'dart:async';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../forgot_pass_page_1.dart';
import '../forgot_pass_page_2.dart';
import '../forgot_pass_page_3.dart';

class ForgotPassNavigator extends StatefulWidget {
  final PageController mainPageController;

  const ForgotPassNavigator({super.key, required this.mainPageController});

  @override
  ForgotPassNavigatorState createState() => ForgotPassNavigatorState();
}

class ForgotPassNavigatorState extends State<ForgotPassNavigator> {
  final PageController _pageController = PageController();
  String _email = '';
  int _remainingTime = 59;
  Timer? _timer;

  void _startTimer() {
    if (_timer != null) return; // Prevent multiple timers
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          _timer = null;
        }
      });
    });
  }

  void _setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _remainingTime = 59;
      _timer = null;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        ForgotPassPage1(
          pageController: _pageController,
          mainPageController: widget.mainPageController,
          onEmailEntered: (email) {
            _setEmail(email);
            _resetTimer();
          },
        ),
        ForgotPassPage2(
          pageController: _pageController,
          email: _email,
        ),
        ForgotPassPage3(pageController: _pageController),
      ],
    );
  }
}
