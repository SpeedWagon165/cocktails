import 'package:cocktails/pages/home/new_recipe/pop_ups/new_alco_page.dart';
import 'package:flutter/material.dart';

import '../../../pages/home/new_recipe/pop_ups/new_non_alco_page.dart';
import '../../../pages/home/new_recipe/pop_ups/new_product_page.dart';

void openIngredientModal(BuildContext context, Widget ingredientPage) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SingleChildScrollView(
        child: IntrinsicHeight(
          child: ingredientPage, // Отображаем нужную страницу с ингредиентами
        ),
      );
    },
  );
}

void openAlcoholicModal(BuildContext context) {
  openIngredientModal(context, const NewRecipeAlcoholicPage());
}

void openNonAlcoholicModal(BuildContext context) {
  openIngredientModal(context, const NewRecipeNonAlcoholicPage());
}

// Открытие продуктов
void openProductModal(BuildContext context) {
  openIngredientModal(context, const NewRecipeProductPage());
}
