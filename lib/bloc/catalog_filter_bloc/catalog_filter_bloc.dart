import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';

part 'catalog_filter_event.dart';
part 'catalog_filter_state.dart';

class IngredientSelectionBloc
    extends Bloc<IngredientSelectionEvent, IngredientSelectionState> {
  final CocktailRepository repository;

  IngredientSelectionBloc(this.repository)
      : super(const IngredientSelectionState(sections: [], selectedItems: {})) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<ToggleSelectionEvent>(_toggleSelectionEvent);
    on<ClearSelectionEvent>(_clearSelectionEvent);
  }

  List<int> getSelectedIngredientIds() {
    final selectedIngredients = <int>[];

    // Проходим по секциям и категориям, чтобы найти выбранные ингредиенты
    state.selectedItems.forEach((sectionId, categories) {
      categories.forEach((category, items) {
        for (var item in items) {
          final categoryData = state.sections
              .expand((section) => section.categories)
              .firstWhere((cat) => cat.name == category);
          final ingredient = categoryData.ingredients
              .firstWhere((ingredient) => ingredient.name == item);
          selectedIngredients.add(ingredient.id);
        }
      });
    });

    return selectedIngredients;
  }

  // Загружаем категории
  void _loadCategories(
      LoadCategoriesEvent event, Emitter<IngredientSelectionState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final sections =
          await repository.fetchSections(); // Fetch sections from API
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Обрабатываем выбор ингредиента
  void _toggleSelectionEvent(ToggleSelectionEvent event,
      Emitter<IngredientSelectionState> emit) async {
    // Получаем текущие выбранные ингредиенты для категории
    final currentSelection =
        state.selectedItems[event.sectionId]?[event.category] ?? [];
    final updatedSelection = List<String>.from(currentSelection);

    if (updatedSelection.contains(event.item)) {
      updatedSelection.remove(event.item);
    } else {
      updatedSelection.add(event.item);
    }

    // Обновляем только если изменилось количество выбранных элементов
    if (updatedSelection.length != currentSelection.length) {
      final updatedItems =
          Map<int, Map<String, List<String>>>.from(state.selectedItems);
      updatedItems[event.sectionId] = {
        ...updatedItems[event.sectionId] ?? {},
        event.category: updatedSelection
      };

      // Обновляем состояние с новым выбором
      emit(state.copyWith(selectedItems: updatedItems));
    }
  }

  // Очищаем выбранные элементы в определенной секции и категории
  void _clearSelectionEvent(
      ClearSelectionEvent event, Emitter<IngredientSelectionState> emit) async {
    final updatedItems =
        Map<int, Map<String, List<String>>>.from(state.selectedItems);

    // Очищаем выбранные ингредиенты для конкретной секции и категории
    updatedItems[event.sectionId]?.remove(event.category);

    emit(state.copyWith(selectedItems: updatedItems));
  }
}
