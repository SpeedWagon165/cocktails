import 'package:cocktails/widgets/base_appbar.dart';
import 'package:cocktails/widgets/cocktail_list/selected_items_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';

class CocktailListPage extends StatefulWidget {
  const CocktailListPage({super.key});

  @override
  State<CocktailListPage> createState() => _CocktailListPageState();
}

class _CocktailListPageState extends State<CocktailListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CocktailListBloc(CocktailRepository())..add(FetchCocktails()),
      child: Scaffold(
        appBar: baseAppBar(context, '18 рецептов', true, true),
        body: Column(
          children: [
            SelectedItemsCarousel(),
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
                        return CocktailCard(cocktail: state.cocktails[index]);
                      },
                    );
                  } else if (state is CocktailError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Начните поиск рецептов'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
