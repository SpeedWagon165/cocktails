import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CocktailCardButtons extends StatefulWidget {
  final bool isCocked;
  final bool isFavorite;
  final Function changeState;

  const CocktailCardButtons({
    super.key,
    required this.isCocked,
    required this.isFavorite,
    required this.changeState,
  });

  @override
  State<CocktailCardButtons> createState() => _CocktailCardButtonsState();
}

class _CocktailCardButtonsState extends State<CocktailCardButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(vertical: 7.0, horizontal: 11.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.isCocked
                  ? const Color(0xFFFFFFFF).withOpacity(0.06)
                  : const Color(0xFFF6B402),
            ),
            child: widget.isCocked
                ? Row(
                    children: [
                      Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightGreenAccent,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/check_icon.svg',
                            height: 10,
                            width: 10,
                          ),
                        ),
                      )
                    ],
                  )
                : Text(
                    "15 баллов",
                    textAlign: TextAlign.center,
                    style:
                        context.text.buttonText18Brown.copyWith(fontSize: 14.0),
                  ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget
                  .changeState(); // Вызываем колбэк для переключения состояния
            },
            child: Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 11.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFFFFFFF).withOpacity(0.06),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isFavorite
                      ? SvgPicture.asset(
                          "assets/images/heart_icon.svg",
                          color: const Color(0xFFFF4747),
                        )
                      : SvgPicture.asset(
                          "assets/images/heart_vector.svg",
                        ),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.isFavorite ? "В избранном" : "В избранное",
                    textAlign: TextAlign.center,
                    style: context.text.bodyText14White
                        .copyWith(color: Colors.white),
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
