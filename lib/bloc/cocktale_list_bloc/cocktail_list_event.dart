part of 'cocktail_list_bloc.dart';

abstract class CocktailListEvent extends Equatable {
  const CocktailListEvent();

  @override
  List<Object> get props => [];
}

class FetchCocktails extends CocktailListEvent {}

// Событие для загрузки коктейлей пользователя
class FetchUserCocktails extends CocktailListEvent {
  final String token;

  const FetchUserCocktails(this.token);

  @override
  List<Object> get props => [token];
}

class FetchFavoriteCocktails extends CocktailListEvent {
  const FetchFavoriteCocktails();

  @override
  List<Object> get props => [];
}

class SearchCocktails extends CocktailListEvent {
  final String query;
  final String? ingredients; // IDs of ingredients (optional)
  final String? tools; // IDs of tools (optional)
  final String? ordering; // Sorting (optional)
  final int? page; // Page number (optional)
  final int? pageSize; // Page size (optional)

  const SearchCocktails({
    required this.query,
    this.ingredients,
    this.tools,
    this.ordering,
    this.page,
    this.pageSize,
  });

  @override
  List<Object> get props => [
        query,
        ingredients ?? '',
        // Заменяем null на пустую строку
        tools ?? '',
        // Заменяем null на пустую строку
        ordering ?? '',
        // Заменяем null на пустую строку
        page ?? 1,
        // Заменяем null на 1 (значение по умолчанию для страницы)
        pageSize ?? 10,
        // Заменяем null на 10 (значение по умолчанию для размера страницы)
      ];
}

class SearchFavoriteCocktails extends CocktailListEvent {
  final String query;
  final String? ingredients;
  final String? tools;
  final String? ordering;
  final int? page;
  final int? pageSize;

  const SearchFavoriteCocktails({
    required this.query,
    this.ingredients,
    this.tools,
    this.ordering,
    this.page,
    this.pageSize,
  });

  @override
  List<Object> get props => [
        query,
        ingredients ?? '',
        // Заменяем null на пустую строку
        tools ?? '',
        // Заменяем null на пустую строку
        ordering ?? '',
        // Заменяем null на пустую строку
        page ?? 1,
        // Заменяем null на 1 (значение по умолчанию для страницы)
        pageSize ?? 10,
      ];
}
