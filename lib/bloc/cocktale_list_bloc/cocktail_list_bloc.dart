import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/cocktail_list_model.dart';
import '../../provider/cocktail_list_get.dart';

part 'cocktail_list_event.dart';
part 'cocktail_list_state.dart';

class CocktailListBloc extends Bloc<CocktailListEvent, CocktailListState> {
  final CocktailRepository repository;

  CocktailListBloc(this.repository) : super(CocktailInitial()) {
    on<FetchCocktails>(_onFetchCocktails);
    on<FetchUserCocktails>(_onFetchUserCocktails); // Обрабатываем новый ивент
    on<SearchCocktails>(_onSearchCocktails);
    on<FetchFavoriteCocktails>(_onFetchFavoriteCocktails);
    on<SearchFavoriteCocktails>(_onSearchFavoriteCocktails);
    on<ToggleFavoriteCocktail>(_onToggleFavoriteCocktail);
    on<ClaimCocktail>(_onClaimCocktail);
  }

  // Получение всех коктейлей (без аутентификации)
  void _onFetchCocktails(
      FetchCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final cocktails = await repository.fetchCocktails();
      emit(CocktailLoaded(cocktails, 'title'));
    } catch (e, stacktrace) {
      log('Error fetching cocktail', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to fetch cocktails: ${e.toString()}'));
    }
  }

  // Получение коктейлей пользователя (с аутентификацией)
  void _onFetchUserCocktails(
      FetchUserCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final cocktails = await repository.fetchUserCocktails(event.token);
      emit(CocktailLoaded(cocktails, 'title'));
    } catch (e, stacktrace) {
      log('Error fetching user cocktails', error: e, stackTrace: stacktrace);
      log(e.toString());
      emit(CocktailError('Failed to fetch user cocktails: ${e.toString()}'));
    }
  }

  void _onSearchCocktails(
      SearchCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final cocktails = await repository.searchCocktails(
        query: event.query,
        ingredients: event.ingredients,
        tools: event.tools,
        ordering: event.ordering,
        page: event.page,
        pageSize: event.pageSize,
      );
      debugPrint('Current sort option: ${event.ordering ?? 'title'}');
      emit(CocktailLoaded(cocktails, event.ordering ?? 'title'));
    } catch (e, stacktrace) {
      log('Error searching cocktails: $e', error: e, stackTrace: stacktrace);
      throw Exception('Failed to search cocktails: $e');
    }
  }

  void _onFetchFavoriteCocktails(
      FetchFavoriteCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final favoriteCocktails = await repository.fetchFavoriteCocktails();
      emit(CocktailLoaded(favoriteCocktails, 'title'));
    } catch (e) {
      emit(CocktailError(
          'Не удалось загрузить избранные рецепты: ${e.toString()}'));
    }
  }

  void _onSearchFavoriteCocktails(
      SearchFavoriteCocktails event, Emitter<CocktailListState> emit) async {
    try {
      emit(CocktailLoading());
      final cocktails = await repository.searchFavoriteCocktails(
        query: event.query,
        ingredients: event.ingredients,
        tools: event.tools,
        ordering: event.ordering,
        page: event.page,
        pageSize: event.pageSize,
      );
      emit(CocktailLoaded(cocktails, 'title'));
    } catch (e) {
      emit(CocktailError(e.toString()));
    }
  }

  void _onToggleFavoriteCocktail(
      ToggleFavoriteCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;

    if (currentState is CocktailLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] =
          true; // Устанавливаем состояние загрузки для конкретного коктейля

      emit(CocktailLoaded(
          currentState.cocktails, currentState.currentSortOption,
          loadingStates: updatedLoadingStates));

      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);

        updatedLoadingStates[event.cocktailId] =
            false; // Сбрасываем состояние загрузки

        // После изменения избранного обновляем список избранных коктейлей
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails()); // Повторный запрос избранных коктейлей
        } else {
          final cocktails = await repository.fetchCocktails();
          emit(CocktailLoaded(cocktails, currentState.currentSortOption,
              loadingStates: updatedLoadingStates));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
  }

  void _onClaimCocktail(
      ClaimCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;

    if (currentState is CocktailLoaded) {
      emit(CocktailLoading()); // Показать состояние загрузки

      try {
        await repository.claimRecipe(event.cocktailId);

        // Обновляем состояние, чтобы показать, что рецепт отмечен как приготовленный
        final updatedCocktails = currentState.cocktails.map((cocktail) {
          return cocktail.id == event.cocktailId
              ? cocktail.copyWith(claimed: true) // Обновляем статус claimed
              : cocktail;
        }).toList();

        emit(CocktailLoaded(updatedCocktails, currentState.currentSortOption));
      } catch (e) {
        emit(
            CocktailError('Не удалось отметить рецепт как приготовленный: $e'));
      }
    }
  }
}
