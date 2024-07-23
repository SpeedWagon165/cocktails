import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_instruction_card.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';

class CocktailInstructionBuilder extends StatefulWidget {
  const CocktailInstructionBuilder({super.key, required this.cocktail});

  final Cocktail cocktail;

  @override
  State<CocktailInstructionBuilder> createState() =>
      _CocktailInstructionBuilderState();
}

class _CocktailInstructionBuilderState
    extends State<CocktailInstructionBuilder> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Приготовление",
              overflow: TextOverflow.clip,
              style: context.text.headline24White,
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.cocktail.instruction.split(".").length,
                  itemBuilder: (context, index) => CocktailInstructionCard(
                      index: index + 1,
                      text: widget.cocktail.instruction.split(".")[index]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
