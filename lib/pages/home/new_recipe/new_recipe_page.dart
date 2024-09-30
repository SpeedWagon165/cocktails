import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/auth/custom_auth_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/home/create_cocktail_widgets/change_cocktail_tile.dart';
import '../../../widgets/home/create_cocktail_widgets/new_recipe_pop_up.dart';
import '../../../widgets/home/create_cocktail_widgets/photo_picker_widget.dart';

class NewRecipePage extends StatelessWidget {
  const NewRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      text: tr('new_recipe.title'), // локализованная строка
                      arrow: true,
                      onPressed: null,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      tr('new_recipe.photo'), // локализованная строка
                      style:
                          context.text.bodyText14White.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    const PhotoPickerWidget(),
                    const SizedBox(height: 24),
                    Text(
                      tr('new_recipe.video'), // локализованная строка
                      style:
                          context.text.bodyText14White.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      labelText: tr('new_recipe.youtube_link'),
                      onChanged: (newValue) {
                        context
                            .read<CocktailCreationBloc>()
                            .add(UpdateRecipeVideoUrlEvent(newValue));
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      labelText: tr('new_recipe.name'),
                      onChanged: (newValue) {
                        context
                            .read<CocktailCreationBloc>()
                            .add(UpdateRecipeTitleEvent(newValue));
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      labelText: tr('new_recipe.description'),
                      expandText: true,
                      onChanged: (newValue) {
                        context
                            .read<CocktailCreationBloc>()
                            .add(UpdateRecipeDescriptionEvent(newValue));
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF343434), width: 1.0),
                          color: Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ChangeCocktailTile(
                            name: tr('new_recipe.alcoholic_drinks'),
                            selectedCount: _getSelectedCount(state, 1),
                            onTap: () {
                              openAlcoholicModal(context);
                            },
                          ),
                          ChangeCocktailTile(
                            name: tr('new_recipe.non_alcoholic_drinks'),
                            selectedCount: _getSelectedCount(state, 2),
                            onTap: () {
                              openNonAlcoholicModal(context);
                            },
                          ),
                          ChangeCocktailTile(
                            name: tr('new_recipe.ingredients'),
                            selectedCount: _getSelectedCount(state, 3),
                            onTap: () {
                              openProductModal(context);
                            },
                          ),
                          ChangeCocktailTile(
                            name: tr('new_recipe.tools'),
                            selectedCount: _getSelectedToolCount(state),
                            onTap: () {
                              openToolModal(context);
                            },
                          ),
                          ChangeCocktailTile(
                            name:
                                '${tr('new_recipe.steps')} (${state.steps.length})',
                            onTap: () {
                              openStepsModal(context);
                            },
                            border: false,
                          ),
                        ])),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: CustomButton(
                              text: tr('buttons.cancel'),
                              // локализованная строка
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: CustomButton(
                              text: tr('buttons.save'), // локализованная строка
                              onPressed: () {
                                if (state.title.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(tr('new_recipe.error_title'))),
                                  );
                                } else if (state.ingredientItems.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(tr(
                                            'new_recipe.error_ingredients'))),
                                  );
                                } else if (state.selectedTools.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(tr('new_recipe.error_tools'))),
                                  );
                                } else {
                                  // Если все поля заполнены, отправляем запрос

                                  context
                                      .read<CocktailCreationBloc>()
                                      .add(SubmitRecipeEvent());
                                  int count = 0;
                                  Navigator.of(context).popUntil((route) {
                                    return count++ == 2;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(tr(
                                            'new_recipe.cocktail_created'))), // Локализация
                                  );
                                }
                              },
                              single: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0B0B0B),
    );
  }
}

int _getSelectedToolCount(CocktailCreationState state) {
  // Подсчитываем количество выбранных инструментов
  return state.selectedTools.length;
}

int _getSelectedCount(CocktailCreationState state, int sectionId) {
  final section = state.selectedItems[sectionId];
  if (section == null) {
    return 0;
  }

  // Подсчитываем все выбранные ингредиенты в каждой категории секции
  return section.entries.fold<int>(0, (total, categoryEntry) {
    return total + categoryEntry.value.length;
  });
}
