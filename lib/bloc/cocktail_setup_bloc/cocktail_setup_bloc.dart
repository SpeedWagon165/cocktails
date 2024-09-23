import 'package:bloc/bloc.dart';

import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';

part 'cocktail_setup_event.dart';
part 'cocktail_setup_state.dart';

class CocktailSelectionBloc
    extends Bloc<CocktailSelectionEvent, CocktailSelectionState> {
  final CocktailRepository repository;

  CocktailSelectionBloc(this.repository)
      : super(CocktailSelectionState(sections: [], selectedItems: {})) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<ToggleSelectionEvent>(_toggleSelectionEvent);
    on<ClearSelectionEvent>(_clearSelectionEvent);
  }

  List<int> getSelectedIngredientIds() {
    final selectedIngredients = <int>[];

    // Проходим по всем категориям и собираем ID выбранных ингредиентов
    state.selectedItems.forEach((category, items) {
      for (var item in items) {
        final categoryData =
            state.sections.expand((section) => section.categories).firstWhere(
                  (cat) => cat.name == category,
                );
        final ingredient = categoryData.ingredients.firstWhere(
          (ingredient) => ingredient.name == item,
        );
        selectedIngredients.add(ingredient.id);
      }
    });

    return selectedIngredients;
  }

  void _loadCategories(
      LoadCategoriesEvent event, Emitter<CocktailSelectionState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final sections =
          await repository.fetchSections(); // Fetch sections from API
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void _toggleSelectionEvent(
      ToggleSelectionEvent event, Emitter<CocktailSelectionState> emit) async {
    final currentSelection = state.selectedItems[event.category] ?? [];
    final updatedSelection = List<String>.from(currentSelection);
    if (updatedSelection.contains(event.item)) {
      updatedSelection.remove(event.item);
    } else {
      updatedSelection.add(event.item);
    }

    final updatedItems = Map<String, List<String>>.from(state.selectedItems)
      ..[event.category] = updatedSelection;
    emit(state.copyWith(selectedItems: updatedItems));
  }

  void _clearSelectionEvent(
      ClearSelectionEvent event, Emitter<CocktailSelectionState> emit) async {
    emit(state.copyWith(selectedItems: {event.category: []}));
  }
}
