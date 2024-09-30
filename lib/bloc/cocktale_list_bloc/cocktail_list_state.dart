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
  final String currentSortOption;
  final Map<int, bool>
      loadingStates; // Хранение состояния загрузки для каждого коктейля

  const CocktailLoaded(this.cocktails, this.currentSortOption,
      {this.loadingStates = const {}});

  @override
  List<Object> get props => [cocktails, currentSortOption, loadingStates];
}

class CocktailError extends CocktailListState {
  final String message;

  const CocktailError(this.message);

  @override
  List<Object> get props => [message];
}
