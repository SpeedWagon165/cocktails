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
      emit(CocktailError('Failed to fetch user cocktails: ${e.toString()}'));
    }
  }
}
