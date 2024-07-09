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
  }

  void _onFetchCocktails(
      FetchCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final cocktails = await repository.fetchCocktails();
      emit(CocktailLoaded(cocktails));
    } catch (e, stacktrace) {
      // Логирование ошибки и стектрейса для отладки
      log('Error fetching cocktails', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to fetch cocktails: ${e.toString()}'));
    }
  }
}
