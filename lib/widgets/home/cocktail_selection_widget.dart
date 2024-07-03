import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import '../custom_checkbox.dart';

class CocktailSelectionView extends StatefulWidget {
  final List<Map<String, List<String>>> categories;
  final bool step;

  const CocktailSelectionView(
      {super.key, required this.categories, required this.step});

  @override
  CocktailSelectionViewState createState() => CocktailSelectionViewState();
}

class CocktailSelectionViewState extends State<CocktailSelectionView> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<CocktailSelectionBloc>(context);

    return BlocBuilder<CocktailSelectionBloc, CocktailSelectionState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedTags(context, cocktailBloc, state),
            const SizedBox(
              height: 24,
            ),
            Text(
              widget.step
                  ? 'Выберете основу коктейля:'
                  : 'Дополнительные ингредиенты:',
              style: context.text.bodyText16White,
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 300,
              child: ListView(
                children: widget.categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  String category = entry.value.keys.first;
                  List<String> items = entry.value.values.first;
                  return buildExpansionTile(
                      context, cocktailBloc, state, category, items,
                      isFirst: index == 0,
                      isLast: index == widget.categories.length - 1);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSelectedTags(BuildContext context,
      CocktailSelectionBloc cocktailBloc, CocktailSelectionState state) {
    final selectedItems = state.selectedItems.entries
        .expand((entry) => entry.value.map((item) => item))
        .toList();

    const int maxVisibleItems = 4;
    bool shouldShowMoreButton = selectedItems.length > maxVisibleItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 1.0,
          children:
              (showAll ? selectedItems : selectedItems.take(maxVisibleItems))
                  .map((item) {
            return Chip(
              backgroundColor: const Color(0xff3E3E3E),
              label: Text(item,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              shape: const StadiumBorder(
                  side: BorderSide(color: Color(0xff343434))),
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
                  size: 16, // Увеличиваем размер иконки
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
          SizedBox(
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
                    showAll ? 'Скрыть' : 'Смотреть все',
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
  }

  Widget buildExpansionTile(
      BuildContext context,
      CocktailSelectionBloc cocktailBloc,
      CocktailSelectionState state,
      String category,
      List<String> items,
      {bool isFirst = false,
      bool isLast = false}) {
    final ScrollController scrollController = ScrollController();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff343434)),
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(10.0) : Radius.zero,
          bottom: isLast ? Radius.circular(10.0) : Radius.zero,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Убираем разделитель
        ),
        child: ExpansionTile(
          title: Text(
            '$category  (${state.selectedItems[category]?.length ?? 0} выбрано)',
            style: context.text.bodyText16White,
          ),

          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          // Увеличиваем размер категорий
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  bottom: isLast ? Radius.circular(10.0) : Radius.zero,
                ),
              ),
              child: SizedBox(
                height: 150, // Ограничиваем высоту виджета
                child: Scrollbar(
                  radius: Radius.circular(30),
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 4,
                  child: ListView(
                    controller: scrollController,
                    children: items.map((item) {
                      return CustomCheckboxListTile(
                        title: item,
                        value: state.selectedItems[category]?.contains(item) ??
                            false,
                        onChanged: (bool? selected) {
                          cocktailBloc
                              .add(ToggleSelectionEvent(category, item));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
