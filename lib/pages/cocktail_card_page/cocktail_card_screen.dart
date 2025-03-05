import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_card_buttons.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_card_slider.dart';
import 'package:cocktails/widgets/coctail_card_widgets/ingredients_list_builder.dart';
import 'package:cocktails/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../models/cocktail_list_model.dart';
import '../../widgets/catalog_widgets/bonus_pop_up.dart';
import '../../widgets/coctail_card_widgets/cocktail_instruction_builder.dart';
import '../../widgets/coctail_card_widgets/tool_list_builder.dart';
import '../../widgets/pure_custom_arrow_back.dart';
import '../../widgets/share_button.dart';
import '../../widgets/store/expandable_text.dart';

class CocktailCardScreen extends StatefulWidget {
  final Cocktail? cocktail;
  final bool favoritePage;
  final int? userId;
  final bool myCocktails;
  final bool catalogPage;
  final bool alcoholPage;

  const CocktailCardScreen({
    super.key,
    this.cocktail,
    required this.userId,
    this.myCocktails = false,
    this.favoritePage = false,
    this.catalogPage = false,
    this.alcoholPage = false,
  });

  @override
  State<CocktailCardScreen> createState() => _CocktailCardScreenState();
}

class _CocktailCardScreenState extends State<CocktailCardScreen> {
  late Cocktail currentCocktail;

  @override
  void initState() {
    super.initState();

    if (widget.cocktail != null) {
      currentCocktail = widget.cocktail!;
    }
  }

  void _shareRecipe() {
    final String cocktailUrl =
        'https://mrbarmister.pro/recipe/${currentCocktail.id}'; // Example URL
    Share.share(
        'Check out this cocktail: ${currentCocktail.name}\n\n$cocktailUrl');
  }

  @override
  Widget build(BuildContext context) {
    final CocktailListBloc bloc;
    if (widget.catalogPage) {
      // Если это страница каталога
      bloc = widget.alcoholPage
          ? context.read<AlcoholicCocktailBloc>()
          : context.read<NonAlcoholicCocktailBloc>();
    } else {
      // Если не страница каталога – используем универсальный блок (например, для избранного или юзерских рецептов)
      bloc = context.read<CocktailListBloc>();
    }
    return BlocConsumer<CocktailListBloc, CocktailListState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is CocktailByIdLoaded) {
            setState(() {
              currentCocktail = state.cocktail;
            });
          }
          print(widget.myCocktails.toString());
          print(state.toString());
          if (widget.myCocktails == true) {
            if (state is UserCocktailLoaded) {
              print("MyCocktailLoaded state received");
              final updatedCocktail = state.userCocktails.firstWhere(
                (c) => c.id == widget.cocktail?.id,
                orElse: () => widget.cocktail!,
              );

              setState(() {
                currentCocktail = updatedCocktail;
              });
              print(currentCocktail.moderationStatus);
            }
          } else {
            if (state is CocktailLoaded) {
              print("CocktailLoaded state received");
              final updatedCocktail = state.cocktails.firstWhere(
                (c) => c.id == widget.cocktail?.id,
                orElse: () => widget.cocktail!,
              );

              setState(() {
                currentCocktail = updatedCocktail;
              });
              print(currentCocktail.moderationStatus);
            }
            if (state is CocktailSearchLoaded) {
              print("CocktailLoaded state received");
              final updatedCocktail = state.cocktails.firstWhere(
                (c) => c.id == widget.cocktail?.id,
                orElse: () => widget.cocktail!,
              );

              setState(() {
                currentCocktail = updatedCocktail;
              });
              print(currentCocktail.moderationStatus);
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  if (state is CocktailByIdLoaded ||
                      state is CocktailLoaded ||
                      state is UserCocktailLoaded ||
                      state is CocktailSearchLoaded)
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
                                : currentCocktail.photo != null
                                    ? [currentCocktail.photo!]
                                    : [],
                            isImageAvailable: currentCocktail.isImageAvailable,
                          ),
                          const SizedBox(height: 12.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<CocktailListBloc,
                                    CocktailListState>(
                                  builder: (context, state) {
                                    bool isFavorite = false;

                                    if (state is CocktailLoaded) {
                                      // Найдите коктейль в загруженных коктейлях или верните текущий коктейль
                                      final cocktail =
                                          state.cocktails.firstWhere(
                                        (c) => c.id == widget.cocktail?.id,
                                        orElse: () => widget
                                            .cocktail!, // Возвращаем оригинальный коктейль, если не найден
                                      );
                                      isFavorite = cocktail.isFavorite;
                                    }

                                    return (widget.userId != null &&
                                            widget.userId.toString() !=
                                                widget.cocktail?.user
                                                    .toString())
                                        ? CocktailCardButtons(
                                            isCocked: currentCocktail.claimed,
                                            // Используем обновленное состояние
                                            isFavorite: isFavorite,
                                            changeState: () {
                                              context
                                                  .read<CocktailListBloc>()
                                                  .add(
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
                                const SizedBox(height: 10.0),
                                IngredientsListBuilder(
                                    cocktail: currentCocktail),
                                const SizedBox(height: 24.0),
                                CocktailInstructionBuilder(
                                    cocktail: currentCocktail),
                                const SizedBox(height: 24.0),
                                ToolsListBuilder(cocktail: currentCocktail),
                                const SizedBox(height: 24.0),
                                if (currentCocktail.moderationStatus == 'Draft')
                                  CustomButton(
                                    text: tr("my_cocktails_page.publish"),
                                    single: true,
                                    gradient: true,
                                    onPressed: () {
                                      print(currentCocktail.moderationStatus
                                          .toString());
                                      context.read<CocktailListBloc>().add(
                                            PublishCocktail(currentCocktail.id),
                                          );
                                      print(currentCocktail.moderationStatus
                                          .toString());
                                    },
                                  ),
                                if (!currentCocktail.claimed &&
                                    widget.userId != null &&
                                    widget.userId.toString() !=
                                        widget.cocktail?.user
                                            .toString()) // Условие для показа кнопки
                                  CustomButton(
                                      text: tr("catalog_page.mark_as_prepared"),
                                      single: true,
                                      gradient: true,
                                      onPressed: () {
                                        if (widget.catalogPage == true) {
                                          if (widget.alcoholPage == true) {
                                            context
                                                .read<AlcoholicCocktailBloc>()
                                                .add(ClaimCocktail(
                                                    currentCocktail.id));
                                          } else {
                                            context
                                                .read<
                                                    NonAlcoholicCocktailBloc>()
                                                .add(ClaimCocktail(
                                                    currentCocktail.id));
                                          }
                                        } else {
                                          context.read<CocktailListBloc>().add(
                                              ClaimCocktail(
                                                  currentCocktail.id));
                                        }
                                        bonusTakePopUp(
                                            context, currentCocktail.name);
                                      }),
                                const SizedBox(height: 24.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  Positioned(
                      top: 26.0,
                      left: 26.0,
                      child: PureCustomArrowBack(
                          isFromDeepLink: state is CocktailByIdLoaded)),
                  Positioned(
                      top: 26.0,
                      right: 26.0,
                      child: ShareButton(
                        onPressed: _shareRecipe,
                      )),
                  if (state is CocktailLoading)
                    const Center(child: CircularProgressIndicator()),
                  Positioned(
                      top: 26.0,
                      left: 26.0,
                      child: PureCustomArrowBack(
                          isFromDeepLink: state is CocktailByIdLoaded)),
                ],
              ),
            ),
          );
        });
  }
}
