import 'dart:ui';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool transper;
  final bool gradient;
  final bool single;
  final bool grey;
  final VoidCallback onPressed;
  final double buttonHeight;
  final bool haveIcon;

  const CustomButton({
    required this.text,
    this.gradient = false,
    this.transper = false,
    this.grey = false,
    required this.single,
    required this.onPressed,
    super.key,
    this.buttonHeight = 60,
    this.haveIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    if (single) {
      if (gradient) {
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: buttonHeight,
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
                      style: context.text.buttonText18Brown
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
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFF6B402),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 0),
                  ),
                  child: haveIcon
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (haveIcon)
                              SvgPicture.asset("assets/images/copy_bold.svg"),
                            if (haveIcon)
                              const SizedBox(
                                width: 10,
                              ),
                            Flexible(
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: context.text.buttonText18Brown
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          text,
                          style: buttonHeight == 60
                              ? context.text.buttonText18Brown
                              : context.text.buttonText18Brown
                                  .copyWith(fontSize: 16),
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
              height: buttonHeight,
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
                  style: context.text.buttonText18Brown
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      } else if (gradient) {
        return SizedBox(
          height: buttonHeight,
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
                style: context.text.buttonText18Brown
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        );
      } else if (grey) {
        return SizedBox(
          height: buttonHeight,
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
              style: context.text.buttonText18Brown
                  .copyWith(color: const Color(0x66FFFFFF)),
            ),
          ),
        );
      } else {
        return SizedBox(
          height: buttonHeight,
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
              style: context.text.buttonText18Brown,
            ),
          ),
        );
      }
    }
  }
}
