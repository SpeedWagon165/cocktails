part of 'cocktail_list_bloc.dart';

abstract class CocktailListEvent extends Equatable {
  const CocktailListEvent();

  @override
  List<Object> get props => [];
}

class FetchCocktails extends CocktailListEvent {
  final int page;
  final int pageSize;

  const FetchCocktails({this.page = 1, this.pageSize = 20});

  @override
  List<Object> get props => [page, pageSize];
}

// Событие для загрузки коктейлей пользователя
class FetchUserCocktails extends CocktailListEvent {
  final String? query;
  final int page;
  final int pageSize;

  const FetchUserCocktails({this.query, this.page = 1, this.pageSize = 50});

  @override
  List<Object> get props => [page, pageSize];
}

class FetchFavoriteCocktails extends CocktailListEvent {
  const FetchFavoriteCocktails();

  @override
  List<Object> get props => [];
}

class SearchCocktails extends CocktailListEvent {
  final String? query;
  final String? ingredients; // IDs of ingredients (optional)
  final String? tools; // IDs of tools (optional)
  final String? ordering; // Sorting (optional)
  final int page; // Page number (optional)
  final int pageSize; // Page size (optional)

  const SearchCocktails({
    this.query,
    this.ingredients,
    this.tools,
    this.ordering,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [
        query ?? '',
        ingredients ?? '',
        // Заменяем null на пустую строку
        tools ?? '',
        // Заменяем null на пустую строку
        ordering ?? '',
        // Заменяем null на пустую строку
      ];
}

class SearchCocktailsLoadMore extends CocktailListEvent {
  final String? query;
  final String? ingredients; // IDs of ingredients (optional)
  final String? tools; // IDs of tools (optional)
  final String? ordering; // Sorting (optional)
  final int page; // Page number (optional)
  final int pageSize; // Page size (optional)

  const SearchCocktailsLoadMore({
    this.query,
    this.ingredients,
    this.tools,
    this.ordering,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [
        query ?? '',
        ingredients ?? '',
        // Заменяем null на пустую строку
        tools ?? '',
        // Заменяем null на пустую строку
        ordering ?? '',
        // Заменяем null на пустую строку
      ];
}

class SearchFavoriteCocktails extends CocktailListEvent {
  final String? query;
  final String? ingredients;
  final String? tools;
  final String? ordering;
  final int page;
  final int pageSize;

  const SearchFavoriteCocktails({
    this.query,
    this.ingredients,
    this.tools,
    this.ordering,
    this.page = 1,
    this.pageSize = 50,
  });

  @override
  List<Object> get props => [
        query ?? '',
        ingredients ?? '',
        // Заменяем null на пустую строку
        tools ?? '',
        // Заменяем null на пустую строку
        ordering ?? '',
        // Заменяем null на пустую строку
      ];
}

class ToggleFavoriteCocktail extends CocktailListEvent {
  final int cocktailId; // ID коктейля
  final bool isFavorite; // Текущее состояние избранного
  final bool favoritePage;

  const ToggleFavoriteCocktail(
      this.cocktailId, this.isFavorite, this.favoritePage);

  @override
  List<Object> get props => [cocktailId, isFavorite, favoritePage];
}

class RefreshFavoriteCocktails extends CocktailListEvent {
  const RefreshFavoriteCocktails();
}

class ClaimCocktail extends CocktailListEvent {
  final int cocktailId;

  const ClaimCocktail(this.cocktailId);

  @override
  List<Object> get props => [cocktailId];
}

class PublishCocktail extends CocktailListEvent {
  final int cocktailId;

  PublishCocktail(this.cocktailId);

  @override
  List<Object> get props => [cocktailId];
}
