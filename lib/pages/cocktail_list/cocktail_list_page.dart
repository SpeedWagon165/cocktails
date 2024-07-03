import 'package:cocktails/widgets/base_appbar.dart';
import 'package:cocktails/widgets/cocktail_list/selected_items_carousel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';

class CocktailListPage extends StatefulWidget {
  const CocktailListPage({super.key});

  @override
  State<CocktailListPage> createState() => _CocktailListPageState();
}

class _CocktailListPageState extends State<CocktailListPage> {
  final List<Cocktail> cocktails = [
    Cocktail(
      name: 'Джин на красной смородине',
      imageUrl: 'assets/images/1aa3b101bb92d5754f486009f6cc29b6.jpeg',
      points: 10,
      hasAllIngredients: true,
      missingIngredients: [],
    ),
    Cocktail(
      name: 'Old Fashion',
      imageUrl: 'assets/images/18d69d8a15af86ee1c05a22baf387939.jpeg',
      points: 20,
      hasAllIngredients: false,
      missingIngredients: ['Водка', 'Кока-кола'],
    ),
    // Добавьте больше коктейлей по необходимости
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar(context, '18 рецептов'),
      body: Column(
        children: [
          SelectedItemsCarousel(),
          Expanded(
            child: ListView.builder(
              itemCount: cocktails.length,
              itemBuilder: (context, index) {
                return CocktailCard(cocktail: cocktails[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
