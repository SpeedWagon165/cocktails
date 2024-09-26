part of 'create_cocktail_bloc.dart';

class CocktailCreationState {
  final List<Section> sections; // Секции с категориями и ингредиентами
  final Map<int, Map<String, List<IngredientItem>>> selectedItems;
  final List<IngredientItem>
      ingredientItems; // Ингредиенты с количеством и типом
  final bool isLoading;
  final String? errorMessage;

  const CocktailCreationState({
    required this.sections,
    required this.selectedItems,
    required this.ingredientItems, // Добавляем список IngredientItem
    this.isLoading = false,
    this.errorMessage,
  });

  CocktailCreationState copyWith({
    List<Section>? sections,
    Map<int, Map<String, List<IngredientItem>>>? selectedItems,
    List<IngredientItem>? ingredientItems, // Для копирования IngredientItem
    bool? isLoading,
    String? errorMessage,
  }) {
    return CocktailCreationState(
      sections: sections ?? this.sections,
      selectedItems: selectedItems ?? this.selectedItems,
      ingredientItems: ingredientItems ?? this.ingredientItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
