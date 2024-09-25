import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';

class CatalogSelectedItemsWrap extends StatefulWidget {
  const CatalogSelectedItemsWrap({super.key});

  @override
  State<CatalogSelectedItemsWrap> createState() =>
      _CatalogSelectedItemsWrapState();
}

class _CatalogSelectedItemsWrapState extends State<CatalogSelectedItemsWrap> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<IngredientSelectionBloc>(context);

    return BlocBuilder<IngredientSelectionBloc, IngredientSelectionState>(
      builder: (context, state) {
        final selectedItems = state.selectedItems.entries
            .expand((entry) => entry.value.map((item) => item))
            .toList();

        const int maxVisibleItems = 7;
        bool shouldShowMoreButton = selectedItems.length > maxVisibleItems;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 1.0,
              children: (showAll
                      ? selectedItems
                      : selectedItems.take(maxVisibleItems))
                  .map((item) {
                return Chip(
                  backgroundColor: const Color(0xff3E3E3E),
                  label: Text(
                    item,
                    style: context.text.bodyText14White,
                  ),
                  shape: const StadiumBorder(
                    side: BorderSide(color: Color(0xff343434)),
                  ),
                  deleteIcon: Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xff3E3E3E),
                      size: 16,
                    ),
                  ),
                  onDeleted: () {
                    final category = state.selectedItems.entries
                        .firstWhere((entry) => entry.value.contains(item))
                        .key;

                    cocktailBloc.add(ToggleSelectionEvent(category, item));
                  },
                );
              }).toList(),
            ),
            if (shouldShowMoreButton)
              const SizedBox(
                height: 12,
              ),
            if (shouldShowMoreButton)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        showAll
                            ? tr(
                                'cocktail_selection.hide') // Локализованное "Скрыть"
                            : tr('cocktail_selection.show_all'),
                        // Локализованное "Смотреть все"
                        style: context.text.bodyText16White
                            .copyWith(color: const Color(0xffB7B7B7)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Color(0xffB7B7B7),
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
