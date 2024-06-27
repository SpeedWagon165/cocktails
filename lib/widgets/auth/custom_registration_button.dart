import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utilities/adaptive_size.dart';

class RegistrationServicesButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RegistrationServicesButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color(0x0FFFFFFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: context.textStyles.bodyText16White,
                  ),
                  Container(
                    width: SizeConfig.heightAdaptive(27),
                    // Адаптивный размер кнопки
                    height: SizeConfig.heightAdaptive(27),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Цвет фона кнопки
                      shape: BoxShape.circle, // Круглая форма
                      border: Border.all(
                        color: const Color(0xFFF6B402),
                        // Полупрозрачная белая обводка
                        width: 1, // Ширина обводки
                      ),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/arrow_forward.svg',
                        width: SizeConfig.heightAdaptive(10),
                        height: SizeConfig.heightAdaptive(10),
                      ),
                      iconSize: 30.0,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24.0,
                      tooltip: 'Back',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
