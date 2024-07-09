part of 'cocktail_list_bloc.dart';

abstract class CocktailListEvent extends Equatable {
  const CocktailListEvent();

  @override
  List<Object> get props => [];
}

class FetchCocktails extends CocktailListEvent {}
