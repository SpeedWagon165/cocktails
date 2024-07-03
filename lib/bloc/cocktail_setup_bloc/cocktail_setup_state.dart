part of 'cocktail_setup_bloc.dart';

class CocktailSelectionState {
  final Map<String, List<String>> selectedItems;

  CocktailSelectionState(this.selectedItems);

  CocktailSelectionState copyWith(Map<String, List<String>>? selectedItems) {
    return CocktailSelectionState(selectedItems ?? this.selectedItems);
  }
}
