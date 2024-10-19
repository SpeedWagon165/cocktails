import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/catalog_widgets/cocktail_filter_widget.dart';
import '../../../widgets/custom_button.dart';

class AlcoholicPage extends StatefulWidget {
  const AlcoholicPage({super.key});

  @override
  AlcoholicPageState createState() => AlcoholicPageState();
}

class AlcoholicPageState extends State<AlcoholicPage> {
  @override
  void initState() {
    super.initState();

    // Запрашиваем категории (алкогольные напитки)
    context.read<IngredientSelectionBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("new_recipe.alcoholic_drinks"),
      onPressed: null,
      arrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Добавляем выбранные ингредиенты в виде Chip
          const CocktailFilterView(
            step: 1,
          ),
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
      ),
    );
  }
}
