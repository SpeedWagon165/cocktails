part of 'create_cocktail_bloc.dart';

@immutable
abstract class CocktailCreationEvent {}

class LoadCategoriesEvent extends CocktailCreationEvent {}

class ToggleSelectionEvent extends CocktailCreationEvent {
  final int sectionId;
  final String category;
  final IngredientItem ingredientItem; // Используем IngredientItem

  ToggleSelectionEvent(this.sectionId, this.category, this.ingredientItem);
}

class AddIngredientEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem; // Изменили на IngredientItem

  AddIngredientEvent(this.ingredientItem);
}

class RemoveIngredientEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem; // Изменили на IngredientItem

  RemoveIngredientEvent(this.ingredientItem);
}

class UpdateIngredientQuantityEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem;
  final String newQuantity;

  UpdateIngredientQuantityEvent(this.ingredientItem, this.newQuantity);
}

class UpdateIngredientTypeEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem;
  final String newType;

  UpdateIngredientTypeEvent(this.ingredientItem, this.newType);
}
