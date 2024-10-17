import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_card_buttons.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_card_slider.dart';
import 'package:cocktails/widgets/coctail_card_widgets/ingredients_list_builder.dart';
import 'package:cocktails/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../models/cocktail_list_model.dart';
import '../../widgets/coctail_card_widgets/cocktail_instruction_builder.dart';
import '../../widgets/coctail_card_widgets/tool_list_builder.dart';
import '../../widgets/pure_custom_arrow_back.dart';
import '../../widgets/store/expandable_text.dart';

class CocktailCardScreen extends StatefulWidget {
  final Cocktail cocktail;
  final int? userId;

  const CocktailCardScreen({
    super.key,
    required this.cocktail,
    required this.userId,
  });

  @override
  State<CocktailCardScreen> createState() => _CocktailCardScreenState();
}

class _CocktailCardScreenState extends State<CocktailCardScreen> {
  late Cocktail currentCocktail;

  @override
  void initState() {
    super.initState();
    currentCocktail =
        widget.cocktail; // Изначально берём коктейль из параметров
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CocktailListBloc, CocktailListState>(
      listener: (context, state) {
        if (state is CocktailLoaded) {
          final updatedCocktail = state.cocktails.firstWhere(
            (c) => c.id == widget.cocktail.id,
            orElse: () => widget.cocktail,
          );
          setState(() {
            currentCocktail = updatedCocktail;
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CocktailCardSlider(
                      videoUrl: currentCocktail.videoUrl,
                      imageUrls: currentCocktail.imageUrl != null
                          ? [currentCocktail.imageUrl!]
                          : [],
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<CocktailListBloc, CocktailListState>(
                            builder: (context, state) {
                              bool isFavorite = false;

                              if (state is CocktailLoaded) {
                                // Найдите коктейль в загруженных коктейлях или верните текущий коктейль
                                final cocktail = state.cocktails.firstWhere(
                                  (c) => c.id == widget.cocktail.id,
                                  orElse: () => widget
                                      .cocktail, // Возвращаем оригинальный коктейль, если не найден
                                );
                                isFavorite = cocktail.isFavorite;
                              }

                              return (widget.userId != null &&
                                      widget.userId.toString() !=
                                          widget.cocktail.user.toString())
                                  ? CocktailCardButtons(
                                      isCocked: currentCocktail.claimed,
                                      // Используем обновленное состояние
                                      isFavorite: isFavorite,
                                      changeState: () {
                                        context.read<CocktailListBloc>().add(
                                              ToggleFavoriteCocktail(
                                                currentCocktail.id,
                                                isFavorite,
                                                false,
                                              ),
                                            );
                                      },
                                    )
                                  : const SizedBox();
                            },
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            currentCocktail.name,
                            overflow: TextOverflow.clip,
                            style: context.text.headline24White,
                          ),
                          const SizedBox(height: 24.0),
                          ExpandableTextWidget(
                            text: currentCocktail.description,
                            titleText: tr("catalog_page.description"),
                          ),
                          const SizedBox(height: 24.0),
                          IngredientsListBuilder(cocktail: currentCocktail),
                          const SizedBox(height: 24.0),
                          CocktailInstructionBuilder(cocktail: currentCocktail),
                          const SizedBox(height: 24.0),
                          ToolsListBuilder(cocktail: currentCocktail),
                          const SizedBox(height: 24.0),
                          if (!currentCocktail.claimed &&
                              widget.userId != null &&
                              widget.userId.toString() !=
                                  widget.cocktail.user
                                      .toString()) // Условие для показа кнопки
                            CustomButton(
                                text: tr("catalog_page.mark_as_prepared"),
                                single: true,
                                gradient: true,
                                onPressed: () {
                                  context
                                      .read<CocktailListBloc>()
                                      .add(ClaimCocktail(currentCocktail.id));
                                }),
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
      ),
    );
  }
}
