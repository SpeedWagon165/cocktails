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

  const CocktailLoaded(this.cocktails);

  @override
  List<Object> get props => [cocktails];
}

class CocktailError extends CocktailListState {
  final String message;

  const CocktailError(this.message);

  @override
  List<Object> get props => [message];
}
