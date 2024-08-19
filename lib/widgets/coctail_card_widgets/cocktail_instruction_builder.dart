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
    // Проверяем, есть ли инструкция и не является ли она пустой строкой
    final hasInstructions = widget.cocktail.instruction != null &&
        widget.cocktail.instruction!.isNotEmpty;

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
              style: context.text.bodyText16White.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.0)),
            child: hasInstructions
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.cocktail.instruction!.length,
                    itemBuilder: (context, index) {
                      final step =
                          widget.cocktail.instruction![(index + 1).toString()];
                      return step!.isNotEmpty
                          ? CocktailInstructionCard(
                              index: index + 1, text: step)
                          : const SizedBox.shrink();
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Инструкции по приготовлению отсутствуют',
                      style: context.text.bodyText14White,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
