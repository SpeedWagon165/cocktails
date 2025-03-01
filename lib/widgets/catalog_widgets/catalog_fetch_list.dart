import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../models/cocktail_list_model.dart';
import '../cocktail_list/cocktail_card.dart';

class CatalogFetchList extends StatefulWidget {
  const CatalogFetchList({
    super.key,
    required this.fetchList,
    required this.hasReachedMax,
  });

  final List<Cocktail> fetchList;
  final bool hasReachedMax;

  @override
  State<CatalogFetchList> createState() => _CatalogFetchListState();
}

class _CatalogFetchListState extends State<CatalogFetchList> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Добавляем обработчик скролла для подгрузки новых страниц
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _currentPage++;
        // Когда дошли до конца списка и если еще есть данные для загрузки
        if (!(context.read<CocktailListBloc>().state as CocktailLoaded)
            .hasReachedMax) {
          context
              .read<CocktailListBloc>()
              .add(FetchCocktails(page: _currentPage));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.hasReachedMax
          ? widget.fetchList.length
          : widget.fetchList.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.fetchList.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CocktailCard(
            cocktail: widget.fetchList[index],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
