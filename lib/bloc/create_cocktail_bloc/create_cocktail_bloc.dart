import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/create_cocktail_model.dart';
import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';

part 'create_cocktail_event.dart';
part 'create_cocktail_state.dart';

class CocktailCreationBloc
    extends Bloc<CocktailCreationEvent, CocktailCreationState> {
  final CocktailRepository repository;

  CocktailCreationBloc(this.repository)
      : super(const CocktailCreationState(
            sections: [], selectedItems: {}, ingredientItems: [])) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<ToggleSelectionEvent>(_toggleSelection);
    on<AddIngredientEvent>(_addIngredient);
    on<RemoveIngredientEvent>(_removeIngredient);
    on<UpdateIngredientQuantityEvent>(_updateIngredientQuantity);
    on<UpdateIngredientTypeEvent>(_updateIngredientType);
  }

  // Загрузка категорий и секций
  void _loadCategories(
      LoadCategoriesEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final sections = await repository.fetchSections();
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Обработка выбора/удаления ингредиента
  void _toggleSelection(
    ToggleSelectionEvent event,
    Emitter<CocktailCreationState> emit,
  ) {
    // Текущие выбранные ингредиенты для категории
    final currentSelection =
        state.selectedItems[event.sectionId]?[event.category] ?? [];
    final updatedSelection = List<IngredientItem>.from(currentSelection);

    if (updatedSelection.contains(event.ingredientItem)) {
      updatedSelection.remove(event.ingredientItem); // Удаляем ингредиент
    } else {
      updatedSelection.add(event.ingredientItem); // Добавляем ингредиент
    }

    // Обновляем состояние с новой информацией о выбранных ингредиентах
    final updatedItems =
        Map<int, Map<String, List<IngredientItem>>>.from(state.selectedItems);
    updatedItems[event.sectionId] = {
      ...updatedItems[event.sectionId] ?? {},
      event.category: updatedSelection,
    };

    emit(state.copyWith(selectedItems: updatedItems));
  }

  // Добавляем ингредиент как IngredientItem с секцией и категорией
  void _addIngredient(
    AddIngredientEvent event,
    Emitter<CocktailCreationState> emit,
  ) {
    final updatedIngredients = List<IngredientItem>.from(state.ingredientItems)
      ..add(IngredientItem(
        ingredient: event.ingredientItem.ingredient,
        // ingredientItem теперь используется
        quantity: event.ingredientItem.quantity,
        type: event.ingredientItem.type,
        sectionId: event.ingredientItem.sectionId,
        // Секция
        category: event.ingredientItem.category, // Категория
      ));
    emit(state.copyWith(ingredientItems: updatedIngredients));
  }

  // Удаляем ингредиент
  void _removeIngredient(
      RemoveIngredientEvent event, Emitter<CocktailCreationState> emit) {
    final updatedIngredients = List<IngredientItem>.from(state.ingredientItems)
      ..remove(event.ingredientItem);
    emit(state.copyWith(ingredientItems: updatedIngredients));
  }

  // Обновляем количество ингредиента
  void _updateIngredientQuantity(UpdateIngredientQuantityEvent event,
      Emitter<CocktailCreationState> emit) {
    final updatedIngredients = state.ingredientItems.map((ingredientItem) {
      return ingredientItem == event.ingredientItem
          ? ingredientItem.copyWith(quantity: event.newQuantity)
          : ingredientItem;
    }).toList();
    emit(state.copyWith(ingredientItems: updatedIngredients));
  }

  // Обновляем тип ингредиента (ml, g и т.д.)
  void _updateIngredientType(
      UpdateIngredientTypeEvent event, Emitter<CocktailCreationState> emit) {
    final updatedIngredients = state.ingredientItems.map((ingredientItem) {
      return ingredientItem == event.ingredientItem
          ? ingredientItem.copyWith(type: event.newType)
          : ingredientItem;
    }).toList();
    emit(state.copyWith(ingredientItems: updatedIngredients));
  }
}
