import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_card_buttons.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_card_slider.dart';
import 'package:cocktails/widgets/coctail_card_widgets/ingredients_list_builder.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';
import '../../widgets/coctail_card_widgets/cocktail_instruction_builder.dart';
import '../../widgets/coctail_card_widgets/tool_list_builder.dart';
import '../../widgets/pure_custom_arrow_back.dart';
import '../../widgets/store/expandable_text.dart';

class CocktailCardScreen extends StatefulWidget {
  const CocktailCardScreen({super.key, required this.cocktail});

  final Cocktail cocktail;

  @override
  State<CocktailCardScreen> createState() => _CocktailCardScreenState();
}

class _CocktailCardScreenState extends State<CocktailCardScreen> {
  bool isCocked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CocktailCardSlider(),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CocktailCardButtons(
                            isCocked: isCocked,
                            isFavorite: widget.cocktail.isFavorite,
                            changeState: () => setState(() {
                                  widget.cocktail.isFavorite =
                                      !widget.cocktail.isFavorite;
                                })),
                        const SizedBox(height: 24.0),
                        Text(
                          widget.cocktail.name,
                          overflow: TextOverflow.clip,
                          style: context.text.headline24White,
                        ),
                        const SizedBox(height: 24.0),
                        ExpandableTextWidget(
                          text: widget.cocktail.description,
                          titleText: 'Описание',
                        ),
                        const SizedBox(height: 24.0),
                        IngredientsListBuilder(cocktail: widget.cocktail),
                        const SizedBox(height: 24.0),
                        CocktailInstructionBuilder(
                          cocktail: widget.cocktail,
                        ),
                        const SizedBox(height: 24.0),
                        ToolsListBuilder(
                          cocktail: widget.cocktail,
                        ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Positioned(
                top: 26.0, left: 26.0, child: PureCustomArrowBack()),
          ],
        ),
      ),
    );
  }
}
