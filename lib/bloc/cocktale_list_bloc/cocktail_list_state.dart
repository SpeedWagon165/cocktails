part of 'cocktail_list_bloc.dart';

// States
abstract class CocktailListState extends Equatable {
  const CocktailListState();

  @override
  List<Object> get props => [];
}

class CocktailInitial extends CocktailListState {}

class CocktailLoading extends CocktailListState {}

class CocktailLoaded extends CocktailListState {
  final List<Cocktail> cocktails;
  final String currentSortOption; // Текущая опция сортировки

  const CocktailLoaded(this.cocktails, this.currentSortOption);

  @override
  List<Object> get props => [cocktails, currentSortOption];
}

class CocktailError extends CocktailListState {
  final String message;

  const CocktailError(this.message);

  @override
  List<Object> get props => [message];
}
