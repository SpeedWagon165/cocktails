import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utilities/adaptive_size.dart';

class CustomArrowBack extends StatelessWidget {
  final String text;
  final bool arrow;
  final bool auth;
  final dynamic onPressed;

  const CustomArrowBack({
    super.key,
    required this.text,
    required this.auth,
    required this.onPressed,
    this.arrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (arrow)
          Container(
            width: SizeConfig.heightAdaptive(30), // Адаптивный размер кнопки
            height: SizeConfig.heightAdaptive(30),
            decoration: BoxDecoration(
              color: Colors.transparent, // Цвет фона кнопки
              shape: BoxShape.circle, // Круглая форма
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5, // Ширина обводки
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/arrow_back.svg',
                width: SizeConfig.heightAdaptive(10), // Адаптивная ширина SVG
                height: SizeConfig.heightAdaptive(10), // Адаптивная высота SVG
              ),
              iconSize: 30.0,
              onPressed: () {
                if (auth) {
                  onPressed();
                } else {
                  Navigator.of(context).pop();
                }
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 24.0,
              tooltip: 'Back',
            ),
          )
        else
          const SizedBox(
            width: 0,
          ),
        const SizedBox(
          width: 16,
        ),
        Text(
          text,
          style: context.textStyles.headline20White,
        ),
      ],
    );
  }
}
