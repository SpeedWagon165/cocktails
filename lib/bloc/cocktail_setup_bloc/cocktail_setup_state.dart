part of 'cocktail_setup_bloc.dart';

class CocktailSelectionState {
  final List<Section> sections; // Now holding sections from the server
  final Map<String, List<String>> selectedItems;
  final bool isLoading;
  final String? errorMessage;

  CocktailSelectionState({
    required this.sections,
    required this.selectedItems,
    this.isLoading = false,
    this.errorMessage,
  });

  CocktailSelectionState copyWith({
    List<Section>? sections,
    Map<String, List<String>>? selectedItems,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CocktailSelectionState(
      sections: sections ?? this.sections,
      selectedItems: selectedItems ?? this.selectedItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
