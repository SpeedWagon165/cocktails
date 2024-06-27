import 'dart:ui';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool transper;
  final bool gradient;
  final bool single;
  final bool grey;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    this.gradient = false,
    this.transper = false,
    this.grey = false,
    required this.single,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (single) {
      if (gradient) {
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF8C82C),
                        Color(0xFFEF7F31),
                        Color(0xFFDD66A9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                    ),
                    child: Text(
                      text,
                      style: context.textStyles.buttonText18Brown
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFF6B402),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                  ),
                  child: Text(
                    text,
                    style: context.textStyles.buttonText18Brown,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    } else {
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
                  backgroundColor: Colors.white.withOpacity(0.15),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.3,
                  ),
                ),
                child: Text(
                  text,
                  style: context.textStyles.buttonText18Brown
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      } else if (gradient) {
        return SizedBox(
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF8C82C),
                  Color(0xFFEF7F31),
                  Color(0xFFDD66A9),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
              ),
              child: Text(
                text,
                style: context.textStyles.buttonText18Brown
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        );
      } else if (grey) {
        return SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: const Color(0x0FFFFFFF),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            ),
            child: Text(
              text,
              style: context.textStyles.buttonText18Brown
                  .copyWith(color: const Color(0x66FFFFFF)),
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
              backgroundColor: const Color(0xFFF6B402),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            ),
            child: Text(
              text,
              style: context.textStyles.buttonText18Brown,
            ),
          ),
        );
      }
    }
  }
}
