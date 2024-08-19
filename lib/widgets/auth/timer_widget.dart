import 'dart:async';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';

class TimerWidget extends StatefulWidget {
  final Function onTimerEnd;

  const TimerWidget({super.key, required this.onTimerEnd});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _start = 59;
  Timer? _timer;

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
        widget.onTimerEnd();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Повторная отправка ',
                style: context.text.bodyText16White,
              ),
              TextSpan(
                text: 'кода через 00:${_start.toString().padLeft(2, '0')}',
                style: context.text.bodyText12Grey.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
