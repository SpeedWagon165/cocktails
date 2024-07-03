import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/home/cocktail_selection_widget.dart';
import '../../widgets/home/step_indicator.dart';

class CocktailSelectionStep1 extends StatefulWidget {
  final PageController pageController;

  const CocktailSelectionStep1({super.key, required this.pageController});

  @override
  CocktailSelectionStep1State createState() => CocktailSelectionStep1State();
}

class CocktailSelectionStep1State extends State<CocktailSelectionStep1> {
  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Подбор коктейля',
      onPressed: null,
      arrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepIndicator(
            activeStep: 0,
          ),
          const CocktailSelectionView(
            categories: [
              {
                'Вино': [
                  'Вино красное',
                  'Вино белое',
                  'Вино розовое',
                  'Вино десертное',
                  'Вино алое',
                ]
              },
              {
                'Водка': ['Водка']
              },
              {
                'Виски': ['Виски']
              },
              {
                'Шампанское': ['Шампанское']
              }
            ],
            step: true,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    text: 'Отмена',
                    grey: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    single: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    text: 'Подтвердить',
                    onPressed: () {
                      widget.pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    single: false,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
