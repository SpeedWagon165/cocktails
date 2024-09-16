import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
  }

  // Получение всех коктейлей (без аутентификации)
  void _onFetchCocktails(
      FetchCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final cocktails = await repository.fetchCocktails();
      emit(CocktailLoaded(cocktails));
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
      emit(CocktailLoaded(cocktails));
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
      emit(CocktailLoaded(cocktails));
    } catch (e, stacktrace) {
      log('Error searching cocktails', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to search cocktails: ${e.toString()}'));
    }
  }

  void _onFetchFavoriteCocktails(
      FetchFavoriteCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final favoriteCocktails = await repository.fetchFavoriteCocktails();
      emit(CocktailLoaded(favoriteCocktails));
    } catch (e) {
      emit(CocktailError(
          'Не удалось загрузить избранные рецепты: ${e.toString()}'));
    }
  }
}
