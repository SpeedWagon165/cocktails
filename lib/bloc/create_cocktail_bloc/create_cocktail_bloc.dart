import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../models/cocktail_list_model.dart';
import '../../models/create_cocktail_model.dart';
import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';
import '../../provider/profile_repository.dart';

part 'create_cocktail_event.dart';
part 'create_cocktail_state.dart';

class CocktailCreationBloc
    extends Bloc<CocktailCreationEvent, CocktailCreationState> {
  final CocktailRepository repository;

  CocktailCreationBloc(this.repository)
      : super(const CocktailCreationState(
          sections: [],
          selectedItems: {},
          ingredientItems: [],
          tools: [],
          selectedTools: [],
          steps: [],
        )) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<AddIngredientEvent>(_addIngredient);
    on<RemoveIngredientEvent>(_removeIngredient);
    on<UpdateIngredientQuantityEvent>(_updateIngredientQuantity);
    on<UpdateIngredientTypeEvent>(_updateIngredientType);
    on<LoadToolsEvent>(_loadTools);
    on<AddToolEvent>(_addTool);
    on<RemoveToolEvent>(_removeTool);
    on<AddStepEvent>(_onAddStep);
    on<UpdateStepEvent>(_onUpdateStep);
    on<RemoveStepEvent>(_onRemoveStep);
    on<UpdatePhotoEvent>(_onUpdatePhoto);
    on<UpdateRecipeTitleEvent>(_onUpdateRecipeTitle);
    on<UpdateRecipeDescriptionEvent>(_onUpdateRecipeDescription);
    on<UpdateRecipeVideoUrlEvent>(_onUpdateRecipeVideoUrl);
    on<UpdateRecipeVideoFileEvent>(_onUpdateVideoFile);
    on<UpdateRecipeVideoAwsKeyEvent>(_onUpdateVideoAwsKey);
    on<SubmitRecipeEvent>(_onSubmitRecipe);
    on<UpdateVideoThumbnailEvent>((e, emit) {
      emit(state.copyWith(videoThumbnailFile: e.thumbnailFile));
    });
  }

  // Загрузка категорий и секций
  void _loadCategories(
      LoadCategoriesEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      print('Loading categories...');
      final sections = await repository.fetchSections();
      print('Loaded sections: $sections');
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      print('Error loading categories: $e');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Добавляем ингредиент как IngredientItem с секцией и категорией
  void _addIngredient(
    AddIngredientEvent event,
    Emitter<CocktailCreationState> emit,
  ) {
    print(
        'Adding ingredient to general list: ${event.ingredientItem.ingredient.name}');

    // Обновляем список ингредиентов
    final updatedIngredients = List<IngredientItem>.from(state.ingredientItems)
      ..add(event.ingredientItem);
    print('Updated ingredientItems: $updatedIngredients');

    // Обновляем selectedItems по секциям и категориям
    final currentSelection = state.selectedItems[event.ingredientItem.sectionId]
            ?[event.ingredientItem.category] ??
        [];
    final updatedSelection = List<IngredientItem>.from(currentSelection)
      ..add(event.ingredientItem);

    final updatedItems =
        Map<int, Map<String, List<IngredientItem>>>.from(state.selectedItems);
    updatedItems[event.ingredientItem.sectionId] = {
      ...updatedItems[event.ingredientItem.sectionId] ?? {},
      event.ingredientItem.category: updatedSelection,
    };

    print(
        'Updated selection for section ${event.ingredientItem.sectionId}, category ${event.ingredientItem.category}: ${updatedItems[event.ingredientItem.sectionId]}');

    emit(state.copyWith(
      ingredientItems: updatedIngredients,
      selectedItems: updatedItems,
    ));
  }

  // Удаляем ингредиент
  void _removeIngredient(
      RemoveIngredientEvent event, Emitter<CocktailCreationState> emit) {
    print('Removing ingredient: ${event.ingredientItem.ingredient.name}');

    // Обновляем список ингредиентов
    final updatedIngredients = List<IngredientItem>.from(state.ingredientItems)
      ..remove(event.ingredientItem);

    // Обновляем selectedItems по секциям и категориям
    final currentSelection = state.selectedItems[event.ingredientItem.sectionId]
            ?[event.ingredientItem.category] ??
        [];
    final updatedSelection = List<IngredientItem>.from(currentSelection)
      ..remove(event.ingredientItem);

    final updatedItems =
        Map<int, Map<String, List<IngredientItem>>>.from(state.selectedItems);
    updatedItems[event.ingredientItem.sectionId] = {
      ...updatedItems[event.ingredientItem.sectionId] ?? {},
      event.ingredientItem.category: updatedSelection,
    };

    emit(state.copyWith(
      ingredientItems: updatedIngredients,
      selectedItems: updatedItems,
    ));
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

  void _loadTools(
      LoadToolsEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      print('Loading tools...');
      final tools = await repository.fetchTools();
      print('Loaded tools: $tools');
      emit(state.copyWith(tools: tools, isLoading: false));
    } catch (e) {
      print('Error loading tools: $e');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Добавляем инструмент
  void _addTool(AddToolEvent event, Emitter<CocktailCreationState> emit) {
    print('Adding tool: ${event.tool.name}');
    final updatedTools = List<Tool>.from(state.selectedTools)..add(event.tool);
    emit(state.copyWith(selectedTools: updatedTools));
  }

  // Удаляем инструмент
  void _removeTool(RemoveToolEvent event, Emitter<CocktailCreationState> emit) {
    print('Removing tool: ${event.tool.name}');
    final updatedTools = List<Tool>.from(state.selectedTools)
      ..remove(event.tool);
    emit(state.copyWith(selectedTools: updatedTools));
  }

  void _onAddStep(AddStepEvent event, Emitter<CocktailCreationState> emit) {
    final updatedSteps = List<RecipeStep>.from(state.steps)..add(event.step);
    emit(state.copyWith(steps: updatedSteps));
  }

  void _onUpdateStep(
      UpdateStepEvent event, Emitter<CocktailCreationState> emit) {
    final updatedSteps = state.steps.map((step) {
      return step.number == event.step.number ? event.step : step;
    }).toList();
    emit(state.copyWith(steps: updatedSteps));
  }

  void _onRemoveStep(
      RemoveStepEvent event, Emitter<CocktailCreationState> emit) {
    // Удаляем шаг
    final updatedSteps =
        state.steps.where((step) => step.number != event.stepNumber).toList();

    // Обновляем номера шагов
    for (int i = 0; i < updatedSteps.length; i++) {
      updatedSteps[i] =
          RecipeStep(number: i + 1, description: updatedSteps[i].description);
    }

    emit(state.copyWith(steps: updatedSteps));
  }

  Future<void> _onUpdatePhoto(
      UpdatePhotoEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(photo: event.photo));
  }

  void _onUpdateRecipeTitle(
      UpdateRecipeTitleEvent event, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateRecipeDescription(
      UpdateRecipeDescriptionEvent event, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onUpdateRecipeVideoUrl(
      UpdateRecipeVideoUrlEvent event, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(videoUrl: event.videoUrl));
  }

  void _onUpdateVideoFile(
      UpdateRecipeVideoFileEvent e, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(videoFile: e.file));
  }

  void _onUpdateVideoAwsKey(
      UpdateRecipeVideoAwsKeyEvent e, Emitter<CocktailCreationState> emit) {
    print('+++ Получен AWS ключ: ${e.awsKey}');
    emit(state.copyWith(videoAwsKey: e.awsKey));
  }

  void _onSubmitRecipe(
      SubmitRecipeEvent event, Emitter<CocktailCreationState> emit) async {
    try {
      // Устанавливаем состояние загрузки
      emit(state.copyWith(isLoading: true));

      // Преобразуем ингредиенты в строку
      final ingredients = state.ingredientItems.map((ingredient) {
        return '{"ingredient":${ingredient.ingredient.id},"quantity":"${ingredient.quantity}","type":"${ingredient.type}"}';
      }).join(',');

      // Преобразуем список инструментов в строку, разделённую запятыми
      final tools = state.selectedTools.map((tool) => tool.id).join(',');

      final instructions = <String, String>{};
      for (var step in state.steps) {
        instructions[step.number.toString()] = step.description;
      }

      final profileRepository = ProfileRepository();

      // Получаем данные профиля из кэша через экземпляр
      final profileData = await profileRepository.getProfileFromCache();
      if (profileData == null) {
        throw Exception('Profile not found in cache');
      }

      final userId = profileData['id'];

      // Собираем все данные для отправки
      final Map<String, dynamic> data = {
        "title": state.title, // Используем данные из состояния
        "description": state.description, // Используем данные из состояния
        "ingredients": ingredients, // Ингредиенты в виде строки
        "tools": tools, // Инструменты в виде строки
        "instruction": jsonEncode(instructions),
        //"video_url": state.videoUrl, // Используем данные из состояния
        "user": userId,
      };
      if (state.videoAwsKey != null) {
        data['video_aws_key'] = state.videoAwsKey;
      } else if (state.videoUrl.isNotEmpty) {
        data['video_url'] = state.videoUrl;
      }
      if (state.photo != null) {
        data['photo'] = await MultipartFile.fromFile(state.photo!.path);
      }

      // Отправляем запрос на сервер через репозиторий
      await repository.createRecipe(data);

      // Если запрос успешен, отключаем индикатор загрузки
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      // В случае ошибки сохраняем сообщение об ошибке
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
