import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool transper;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.textColor,
    required this.color,
    this.transper = false,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (transper) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: color.withOpacity(0.15),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.3,
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: color,
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }
}
