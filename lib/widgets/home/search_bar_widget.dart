import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';

class CustomSearchBar extends StatelessWidget {
  final bool isFavorites; // Добавляем флаг для поиска по избранным
  final TextEditingController? controller;
  final bool userRecipes;

  const CustomSearchBar({
    super.key,
    this.isFavorites = false,
    this.controller,
    this.userRecipes = false, // По умолчанию флаг отключён
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller != null ? controller : null,
              decoration: InputDecoration(
                hintText: tr("search.search"),
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  // В зависимости от флага, выполняем разные запросы
                  if (isFavorites) {
                    context.read<CocktailListBloc>().add(
                          SearchFavoriteCocktails(
                            query: query,
                            page: 1,
                            pageSize: 50,
                            // Передача дополнительных параметров
                          ),
                        );
                  } else if (userRecipes) {
                    context.read<CocktailListBloc>().add(
                          FetchUserCocktails(
                            query: query,
                            page: 1,
                            pageSize: 50,
                          ),
                        );
                  } else {
                    context.read<CocktailListBloc>().add(
                          SearchCocktails(
                            query: query,
                            page: 1,
                            pageSize: 20,
                          ),
                        );
                  }
                } else {
                  if (isFavorites) {
                    context
                        .read<CocktailListBloc>()
                        .add(const FetchFavoriteCocktails());
                  } else if (userRecipes) {
                    context.read<CocktailListBloc>().add(
                          FetchUserCocktails(),
                        );
                  } else {
                    context.read<CocktailListBloc>().add(FetchCocktails());
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
