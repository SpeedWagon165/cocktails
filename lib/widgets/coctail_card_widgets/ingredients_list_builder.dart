import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';
import 'ingredients_list_card.dart';

class IngredientsListBuilder extends StatelessWidget {
  const IngredientsListBuilder({super.key, required this.cocktail});

  final Cocktail cocktail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Ингредиенты",
          overflow: TextOverflow.clip,
          style: context.text.headline24White,
        ),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF343434), width: 1.0),
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cocktail.ingredientCount,
                itemBuilder: (context, index) => IngredientsListCard(
                    title: cocktail.ingredients[index].toString(),
                    count: 50,
                    border:
                        index == cocktail.ingredientCount - 1 ? false : true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
