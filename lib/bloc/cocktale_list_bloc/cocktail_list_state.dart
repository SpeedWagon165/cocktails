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
  final Map<int, bool> loadingStates;
  final bool hasReachedMax; // Добавляем флаг для пагинации

  const CocktailLoaded(
    this.cocktails,
    this.currentSortOption, {
    this.loadingStates = const {},
    this.hasReachedMax = false, // Значение по умолчанию
  });

  // Метод copyWith для обновления состояния
  CocktailLoaded copyWith({
    List<Cocktail>? cocktails,
    String? currentSortOption,
    Map<int, bool>? loadingStates,
    bool? hasReachedMax,
  }) {
    return CocktailLoaded(
      cocktails ?? this.cocktails,
      currentSortOption ?? this.currentSortOption,
      loadingStates: loadingStates ?? this.loadingStates,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props =>
      [cocktails, currentSortOption, loadingStates, hasReachedMax];
}

class CocktailError extends CocktailListState {
  final String message;

  const CocktailError(this.message);

  @override
  List<Object> get props => [message];
}
