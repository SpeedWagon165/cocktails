import 'package:cocktails/pages/cocktail_card_page/cocktail_card_screen.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../models/cocktail_list_model.dart';

class CocktailCard extends StatelessWidget {
  final bool favoritePage;

  final Cocktail cocktail;

  const CocktailCard({
    super.key,
    required this.cocktail,
    this.favoritePage = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocktailListBloc, CocktailListState>(
      builder: (context, state) {
        bool isLoading = false;

        if (state is CocktailLoaded) {
          isLoading = state.loadingStates[cocktail.id] ?? false;
        }

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CocktailCardScreen(
                  cocktail: cocktail,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Card(
                color: const Color(0xff1C1C1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xff343434)),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: cocktail.imageUrl != null
                          ? Image.network(
                              cocktail.imageUrl!,
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: 190,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(cocktail.name,
                          style: context.text.headline24White
                              .copyWith(fontSize: 18)),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          // Отправляем событие для переключения статуса избранного
                          context.read<CocktailListBloc>().add(
                                ToggleFavoriteCocktail(cocktail.id,
                                    cocktail.isFavorite, favoritePage),
                              );
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          strokeWidth: 2,
                        )
                      : Icon(
                          cocktail.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              cocktail.isFavorite ? Colors.red : Colors.white,
                          size: 30,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
