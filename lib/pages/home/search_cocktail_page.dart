import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';
import '../../widgets/cocktail_list/selected_items_carousel_widget.dart';
import '../../widgets/custom_arrowback.dart';

class SearchCocktailPage extends StatelessWidget {
  const SearchCocktailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CocktailListBloc(CocktailRepository())..add(FetchCocktails()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                CustomArrowBack(
                  text: tr('catalog_page.title'), // Локализация заголовка
                  onPressed: null,
                  secondIcon: true,
                  onSecondIconTap: () {
                    Navigator.of(context).pop();
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
                            child: Text(tr(
                                'errors.server_error'))); // Локализация ошибок
                      }
                      return Center(
                        child: Text(tr(
                            'catalog_page.start_search')), // Локализация сообщения
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
