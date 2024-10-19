import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/home/cocktail_selection_widget.dart';
import '../../../widgets/home/step_indicator.dart';

class CocktailSelectionStep2 extends StatefulWidget {
  final PageController pageController;

  const CocktailSelectionStep2({super.key, required this.pageController});

  @override
  CocktailSelectionStep2State createState() => CocktailSelectionStep2State();
}

class CocktailSelectionStep2State extends State<CocktailSelectionStep2> {
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
            activeStep: 1,
          ),
          const CocktailSelectionView(
            categories: [
              {
                'Б/а напитки': [
                  'Тоник',
                  'Кока-кола',
                  'Спрайт',
                  'Фанта',
                ]
              },
              {
                'Продукты': [
                  'Лёд',
                  'Лимон',
                  'Лайм',
                ]
              },
            ],
            step: false,
          ),
          const SizedBox(height: 20),
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
                      widget.pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    single: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    gradient: true,
                    text: 'Подобрать',
                    onPressed: () {
                      widget.pageController.animateToPage(
                        2,
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
