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
