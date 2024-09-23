import 'package:cocktails/pages/home/popups/cocktail_filter_pop_up.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';
import '../../widgets/cocktail_list/selected_items_carousel_widget.dart';
import '../../widgets/custom_arrowback.dart';

class SearchCocktailPage extends StatefulWidget {
  const SearchCocktailPage({super.key});

  @override
  SearchCocktailPageState createState() => SearchCocktailPageState();
}

class SearchCocktailPageState extends State<SearchCocktailPage> {
  late CocktailListBloc cocktailListBloc;

  @override
  void initState() {
    super.initState();

    // Получаем блок для управления коктейлями
    cocktailListBloc = CocktailListBloc(CocktailRepository());

    // Подписываемся на изменения в CocktailSelectionBloc
    final cocktailSelectionBloc =
        BlocProvider.of<CocktailSelectionBloc>(context);

    // Обновляем список коктейлей каждый раз, когда изменяются выбранные ингредиенты
    cocktailSelectionBloc.stream.listen((selectionState) {
      // Получаем выбранные ингредиенты
      final selectedIngredientIds =
          cocktailSelectionBloc.getSelectedIngredientIds();

      // Отправляем новое событие поиска с обновленными ингредиентами
      cocktailListBloc.add(SearchFavoriteCocktails(
        ingredients: selectedIngredientIds.isNotEmpty
            ? selectedIngredientIds.join(',') // Преобразуем в строку
            : null, // Если ингредиенты не выбраны
      ));
    });

    // Инициализируем первый поиск при открытии страницы
    final selectedIngredientIds =
        cocktailSelectionBloc.getSelectedIngredientIds();

    cocktailListBloc.add(SearchFavoriteCocktails(
      ingredients: selectedIngredientIds.isNotEmpty
          ? selectedIngredientIds.join(',')
          : null,
    ));
  }

  @override
  void dispose() {
    // Закрываем блок при удалении виджета
    cocktailListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cocktailListBloc,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                BlocBuilder<CocktailListBloc, CocktailListState>(
                  builder: (context, state) {
                    String titleText =
                        "0 ${tr('cocktail_selection.recipes')}"; // Заголовок по умолчанию

                    // Если загружены коктейли, показываем их количество
                    if (state is CocktailLoaded) {
                      final count = state.cocktails.length;
                      titleText =
                          "$count ${tr('cocktail_selection.recipes')}"; // Например: "18 рецептов"
                    }
                    return CustomAppBar(
                      text: titleText,
                      onPressed: null,
                      secondIcon: true,
                      onSecondIconTap: () {
                        cocktailFilterPopUp(context);
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                const SelectedItemsCarousel(),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<CocktailListBloc, CocktailListState>(
                    builder: (context, state) {
                      if (state is CocktailLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CocktailLoaded) {
                        return ListView.builder(
                          itemCount: state.cocktails.length,
                          itemBuilder: (context, index) {
                            return CocktailCard(
                              cocktail: state.cocktails[index],
                            );
                          },
                        );
                      } else if (state is CocktailError) {
                        return Center(
                          child: Text(
                            tr('cocktail_selection.no_cocktails'),
                            style: context.text.bodyText16White,
                          ),
                        );
                      }
                      return Center(
                        child: Text(tr('catalog_page.start_search')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
