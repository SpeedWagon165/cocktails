import 'package:cocktails/pages/catalog/filter_pages/products_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import '../../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/catalog_widgets/catalog_selected_wrap.dart';
import '../../../widgets/catalog_widgets/sort_expansion_tile.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/home/create_cocktail_widgets/change_cocktail_tile.dart';
import 'alcoholic_page.dart';
import 'non_alcoholic_page.dart';

class FilterMainPage extends StatelessWidget {
  const FilterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<IngredientSelectionBloc>(context);

    return BasePopup(
      text: "Фильтр",
      onPressed: null,
      arrow: false,
      child: BlocBuilder<IngredientSelectionBloc, IngredientSelectionState>(
        builder: (context, state) {
          // Получаем количество выбранных элементов для каждой категории по id
          final alcoholicCount =
              _getSelectedCount(state, 1); // id категории "Алкогольные напитки"
          final nonAlcoholicCount =
              _getSelectedCount(state, 2); // id категории "Б/а напитки"
          final productsCount =
              _getSelectedCount(state, 3); // id категории "Продукты"

          // Собираем все выбранные ингредиенты в виде строки, готовой для передачи в API
          final selectedIngredients = _getSelectedIngredients(state);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CocktailListBloc, CocktailListState>(
                builder: (context, state) {
                  if (state is CocktailLoaded) {
                    return SortExpansionTile(
                      currentSortOption: state.currentSortOption,
                    );
                  }
                  return const SortExpansionTile(
                    currentSortOption: 'title',
                  );
                },
              ),
              const SizedBox(height: 16),
              const CatalogSelectedItemsWrap(),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFF343434), width: 1.0),
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChangeCocktailTile(
                      name: tr('new_recipe.alcoholic_drinks'),
                      selectedCount: alcoholicCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AlcoholicPage(),
                          ),
                        );
                      },
                    ),
                    ChangeCocktailTile(
                      name: tr('new_recipe.non_alcoholic_drinks'),
                      selectedCount: nonAlcoholicCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NonAlcoholicPage(),
                          ),
                        );
                      },
                    ),
                    ChangeCocktailTile(
                      name: tr('new_recipe.ingredients'),
                      selectedCount: productsCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProductsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CustomButton(
                        text: tr("buttons.cancel"),
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
                        text: tr("buttons.confirm"),
                        onPressed: () {
                          // Передаем ингредиенты и сортировку через блок
                          final currentSortOption = context
                                  .read<CocktailListBloc>()
                                  .state is CocktailLoaded
                              ? (context.read<CocktailListBloc>().state
                                      as CocktailLoaded)
                                  .currentSortOption
                              : 'title';

                          context.read<CocktailListBloc>().add(
                                SearchCocktails(
                                  ordering: currentSortOption,
                                  ingredients:
                                      selectedIngredients, // Передаем выбранные ингредиенты
                                ),
                              );
                          Navigator.pop(context);
                        },
                        single: false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _getSelectedIngredients(IngredientSelectionState state) {
    final selectedItems = state.selectedItems;
    List<String> selectedIngredientsIds = [];

    // Проходим по всем секциям
    selectedItems.forEach((sectionId, categories) {
      categories.forEach((categoryId, ingredients) {
        print(ingredients); // Посмотрите, что содержится в ingredients
      });
    });

    // Возвращаем строку с идентификаторами ингредиентов через запятую
    return selectedIngredientsIds.join(',');
  }

  // Функция для получения количества выбранных ингредиентов в категории по id
  int _getSelectedCount(IngredientSelectionState state, int sectionId) {
    // Проверяем, есть ли в состоянии секция с указанным ID
    final section = state.selectedItems[sectionId];

    if (section == null) {
      // Если секция отсутствует, возвращаем 0
      return 0;
    }

    // Подсчитываем все выбранные ингредиенты в каждой категории секции
    return section.entries.fold<int>(0, (total, categoryEntry) {
      return total + categoryEntry.value.length;
    });
  }
}
