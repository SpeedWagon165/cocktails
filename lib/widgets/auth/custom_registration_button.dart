import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../pages/auth/popups/auth_pop_up.dart';
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
                    style: context.text.bodyText16White,
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

class CustomRegistrationButton extends StatelessWidget {
  const CustomRegistrationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        authPopUp(context);
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8C82C),
                Color(0xFFEF7F31),
                Color(0xFFDD66A9),
              ],
            ),
            width: 2,
          ),
        ),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Text('Зарегестрироваться',
              style: context.text.bodyText16White.copyWith(fontSize: 15)),
        ),
      ),
    );
  }
}
