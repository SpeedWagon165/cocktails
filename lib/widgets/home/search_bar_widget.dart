import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

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
              decoration: const InputDecoration(
                hintText: 'Найти',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  context.read<CocktailListBloc>().add(
                        SearchCocktails(
                          query: query,
                          // Передача дополнительных параметров (пример)
                          ingredients: null,
                          tools: null,
                          ordering: '-title',
                          page: null,
                          pageSize: null,
                        ),
                      );
                } else {
                  context.read<CocktailListBloc>().add(FetchCocktails());
                }
              },
            ),
          ),
          const Icon(Icons.mic, color: Colors.white54),
        ],
      ),
    );
  }
}
