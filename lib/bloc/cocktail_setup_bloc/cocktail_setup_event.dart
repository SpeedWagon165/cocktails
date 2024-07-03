part of 'cocktail_setup_bloc.dart';

abstract class CocktailSelectionEvent {}

class ToggleSelectionEvent extends CocktailSelectionEvent {
  final String category;
  final String item;

  ToggleSelectionEvent(this.category, this.item);
}

class ClearSelectionEvent extends CocktailSelectionEvent {
  final String category;

  ClearSelectionEvent(this.category);
}
