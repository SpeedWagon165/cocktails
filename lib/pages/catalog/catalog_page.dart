import 'package:cocktails/pages/catalog/pop_up/filter_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    // Запускаем загрузку коктейлей при инициализации страницы
    Future.microtask(() {
      context.read<CocktailListBloc>().add(FetchCocktails());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(
            children: [
              CustomAppBar(
                text: tr('catalog_page.title'),
                // Локализация заголовка
                onPressed: null,
                secondIcon: true,
                arrow: false,
                onSecondIconTap: () {
                  openFilterModal(context);
                },
              ),
              const SizedBox(height: 10),
              const CustomSearchBar(),
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
                              tr('errors.server_error'))); // Локализация ошибок
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
    );
  }
}
