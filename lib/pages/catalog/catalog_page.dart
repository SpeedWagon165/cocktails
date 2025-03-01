import 'package:cocktails/pages/catalog/pop_up/filter_pop_up.dart';
import 'package:cocktails/widgets/catalog_widgets/catalog_fetch_list.dart';
import 'package:cocktails/widgets/catalog_widgets/catalog_search_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../widgets/catalog_widgets/custom_tab_indicator.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CocktailListBloc>().add(FetchCocktails());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Количество вкладок
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                /// Верхний бар
                CustomAppBar(
                  text: tr('catalog_page.title'),
                  onPressed: null,
                  secondIcon: true,
                  arrow: false,
                  onSecondIconTap: () {
                    openFilterModal(context);
                  },
                ),
                const SizedBox(height: 10),

                /// Поле поиска
                CustomSearchBar(
                  controller: editingController,
                ),
                const SizedBox(height: 16),

                /// Вкладки
                TabBar(
                  labelColor: Colors.white,
                  // Цвет активной вкладки
                  unselectedLabelColor: Colors.grey,
                  // Цвет неактивной вкладки
                  indicator: CustomTabIndicator(),
                  // Кастомный индикатор
                  indicatorWeight: 0.0,
                  dividerHeight: 0,

                  tabs: [
                    Tab(text: tr('catalog_page.all')), // Алко
                    Tab(text: tr('catalog_page.favorites')), // Безалко
                  ],
                ),

                /// Содержимое вкладок
                Expanded(
                  child: TabBarView(
                    children: [
                      /// Вкладка 1: Все коктейли
                      BlocBuilder<CocktailListBloc, CocktailListState>(
                        builder: (context, state) {
                          if (state is CocktailLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is CocktailLoaded) {
                            return CatalogFetchList(
                              fetchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                            );
                          } else if (state is CocktailSearchLoaded) {
                            return CatalogSearchList(
                              searchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                              query: editingController.text,
                              searchPage: true,
                            );
                          } else if (state is CocktailError) {
                            return Center(
                              child: Text(tr('errors.server_error')),
                            );
                          }
                          return Center(
                            child: Text(tr('catalog_page.start_search')),
                          );
                        },
                      ),

                      /// Вкладка 2: Избранные коктейли (пока заглушка, можно переделать)
                      BlocBuilder<CocktailListBloc, CocktailListState>(
                        builder: (context, state) {
                          if (state is CocktailLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is CocktailLoaded) {
                            return CatalogFetchList(
                              fetchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                            );
                          } else if (state is CocktailSearchLoaded) {
                            return CatalogSearchList(
                              searchList: state.cocktails,
                              hasReachedMax: state.hasReachedMax,
                              query: editingController.text,
                              searchPage: true,
                            );
                          } else if (state is CocktailError) {
                            return Center(
                              child: Text(tr('errors.server_error')),
                            );
                          }
                          return Center(
                            child: Text(tr('catalog_page.start_search')),
                          );
                        },
                      ),
                    ],
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
