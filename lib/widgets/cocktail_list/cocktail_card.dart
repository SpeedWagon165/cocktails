import 'package:cocktails/pages/cocktail_card_page/cocktail_card_screen.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        int? userId;

        if (profileState is ProfileLoaded) {
          userId = profileState.profileData['id']; // Получаем id пользователя
        }
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
                      userId: userId,
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
                  if (userId != null &&
                      userId.toString() != cocktail.user.toString())
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                                strokeWidth: 2,
                              )
                            : Icon(
                                cocktail.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: cocktail.isFavorite
                                    ? Colors.red
                                    : Colors.white,
                                size: 30,
                              ),
                      ),
                    ),
                  if (userId != null &&
                      userId.toString() != cocktail.user.toString())
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: cocktail.claimed
                              ? Colors.white.withOpacity(0.2)
                              : const Color(0xFFF6B402),
                        ),
                        child: cocktail.claimed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff68C248),
                                    ),
                                    child: const Icon(Icons.check,
                                        size: 15, color: Colors.white),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(tr("catalog_page.prepared"),
                                      style: context.text.bodyText14White),
                                ],
                              )
                            : Text(
                                tr('bonus_screen.points',
                                    namedArgs: {'points': '15'}),
                                style: context.text.buttonText18Brown
                                    .copyWith(fontSize: 14.0),
                              ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
