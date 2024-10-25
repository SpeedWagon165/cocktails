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
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    // Загружаем первую страницу при инициализации
    Future.microtask(() {
      context.read<CocktailListBloc>().add(FetchCocktails());
    });

    // Добавляем обработчик скролла для подгрузки новых страниц
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Когда дошли до конца списка и если еще есть данные для загрузки
        if (!(context.read<CocktailListBloc>().state as CocktailLoaded)
            .hasReachedMax) {
          _currentPage++;
          context
              .read<CocktailListBloc>()
              .add(FetchCocktails(page: _currentPage));
        }
      }
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
                        controller: _scrollController,
                        itemCount: state.hasReachedMax
                            ? state.cocktails.length
                            : state.cocktails.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.cocktails.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return CocktailCard(
                              cocktail: state.cocktails[index],
                            );
                          }
                        },
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
