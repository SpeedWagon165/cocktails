import 'package:cocktails/pages/catalog/filter_pages/products_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import '../../../models/ingredient_category_model.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/catalog_widgets/catalog_selected_wrap.dart';
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: 'По популярности',
                items: ['По популярности', 'По новизне'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (_) {},
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

  // Функция для получения количества выбранных ингредиентов в категории по id
  int _getSelectedCount(IngredientSelectionState state, int categoryId) {
    final section = state.sections.firstWhere(
      (section) => section.id == categoryId,
      orElse: () => Section(id: 0, name: '', categories: []),
    );

    return section.categories.fold<int>(0, (prev, category) {
      return prev + (state.selectedItems[category.id.toString()]?.length ?? 0);
    });
  }
}
