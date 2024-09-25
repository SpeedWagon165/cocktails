part of 'catalog_filter_bloc.dart';

@immutable
abstract class IngredientSelectionEvent {}

class ToggleSelectionEvent extends IngredientSelectionEvent {
  final String category;
  final String item;

  ToggleSelectionEvent(this.category, this.item);
}

class ClearSelectionEvent extends IngredientSelectionEvent {
  final String category;

  ClearSelectionEvent(this.category);
}

class LoadCategoriesEvent extends IngredientSelectionEvent {}
