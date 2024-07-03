part of 'cocktail_setup_bloc.dart';

class CocktailSelectionState {
  final Map<String, List<String>> selectedItems;

  CocktailSelectionState(this.selectedItems);

  CocktailSelectionState copyWith(Map<String, List<String>>? updatedItems) {
    // Объединяем старые и новые значения, чтобы не терять данные
    final newItems = Map<String, List<String>>.from(selectedItems);
    if (updatedItems != null) {
      updatedItems.forEach((key, value) {
        newItems[key] = value;
      });
    }
    return CocktailSelectionState(newItems);
  }
}
