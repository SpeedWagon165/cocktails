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
    on<SearchCocktailsLoadMore>(_onSearchCocktailsLoadMore);
    on<FetchFavoriteCocktails>(_onFetchFavoriteCocktails);
    on<SearchFavoriteCocktails>(_onSearchFavoriteCocktails);
    on<ToggleFavoriteCocktail>(_onToggleFavoriteCocktail);
    on<ClaimCocktail>(_onClaimCocktail);
    on<PublishCocktail>(_onPublishCocktail);
  }

  // Получение всех коктейлей (без аутентификации)
  void _onFetchCocktails(
      FetchCocktails event, Emitter<CocktailListState> emit) async {
    final currentState = state;

    // Проверяем, если уже загружены коктейли (для подгрузки страниц)
    if (currentState is CocktailLoaded) {
      print(
          "Current state is CocktailLoaded with ${currentState.cocktails.length} fetch cocktails.");
      try {
        // Загружаем следующую страницу
        final newCocktails = await repository.fetchCocktails(
          page: event.page,
          pageSize: event.pageSize,
        );

        if (newCocktails.isEmpty) {
          // Если новых данных нет, не обновляем состояние
          emit(currentState.copyWith(hasReachedMax: true));
        } else if (newCocktails.length < event.pageSize) {
          // Если количество полученных коктейлей меньше, чем запрашивалось
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails,
            hasReachedMax: true, // Устанавливаем, что больше нет данных
          ));
        } else {
          // Обновляем список коктейлей, добавляя новые элементы
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails,
            hasReachedMax: false,
          ));
        }
      } catch (e, stacktrace) {
        log('Error fetching more cocktails', error: e, stackTrace: stacktrace);
        emit(CocktailError('Failed to load more cocktails: ${e.toString()}'));
      }
    } else {
      // Если это первая загрузка
      emit(CocktailLoading());
      try {
        final cocktails = await repository.fetchCocktails(
          page: event.page,
          pageSize: event.pageSize,
        );

        if (cocktails.length < event.pageSize) {
          emit(CocktailLoaded(cocktails, 'title', hasReachedMax: true));
        } else {
          emit(CocktailLoaded(cocktails, 'title', hasReachedMax: false));
        }
      } catch (e, stacktrace) {
        log('Error fetching cocktails', error: e, stackTrace: stacktrace);
        emit(CocktailError('Failed to fetch cocktails: ${e.toString()}'));
      }
    }
  }

  // Получение коктейлей пользователя (с аутентификацией)
  void _onFetchUserCocktails(
      FetchUserCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final userCocktails = await repository.fetchUserCocktails(
        query: event.query,
        page: event.page,
        pageSize: event.pageSize,
      );
      emit(UserCocktailLoaded(userCocktails));
    } catch (e, stacktrace) {
      log('Error fetching user cocktails', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to fetch user cocktails: ${e.toString()}'));
    }
  }

  void _onSearchCocktails(
      SearchCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      print(event.ingredients);
      final cocktailsResponse = await repository.searchCocktails(
        query: event.query,
        ingredients: event.ingredients,
        tools: event.tools,
        ordering: event.ordering,
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(CocktailSearchLoaded(
          cocktailsResponse.cocktails, event.ordering ?? 'title',
          hasReachedMax: cocktailsResponse.cocktails.length < event.pageSize,
          count: cocktailsResponse
              .count)); // Устанавливаем состояние hasReachedMax
    } catch (e, stacktrace) {
      log('Error searching cocktails: $e', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to search cocktails: $e'));
    }
  }

  void _onSearchCocktailsLoadMore(
      SearchCocktailsLoadMore event, Emitter<CocktailListState> emit) async {
    final currentState = state;
    if (currentState is CocktailSearchLoaded) {
      try {
        print(event.query);
        print(event.page);
        print(event.ingredients);
        print(event.pageSize);
        // Загружаем следующую страницу
        final newCocktails = await repository.searchCocktails(
          query: event.query,
          ingredients: event.ingredients,
          page: event.page,
          pageSize: event.pageSize,
        );

        if (newCocktails.cocktails.isEmpty) {
          // Если новых данных нет, не обновляем состояние
          emit(currentState.copyWith(hasReachedMax: true));
        } else if (newCocktails.cocktails.length < event.pageSize) {
          // Если количество полученных коктейлей меньше, чем запрашивалось
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails.cocktails,
            hasReachedMax: true, // Устанавливаем, что больше нет данных
          ));
        } else {
          // Обновляем список коктейлей, добавляя новые элементы
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails.cocktails,
            hasReachedMax: false,
          ));
        }
      } catch (e, stacktrace) {
        log('Error fetching more cocktails', error: e, stackTrace: stacktrace);
        emit(CocktailError('Failed to load more cocktails: ${e.toString()}'));
      }
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
    emit(CocktailLoading());
    try {
      final cocktails = await repository.searchFavoriteCocktails(
        query: event.query,
        ingredients: event.ingredients,
        tools: event.tools,
        ordering: event.ordering,
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(CocktailLoaded(cocktails, 'title',
          hasReachedMax: cocktails.length <
              event.pageSize)); // Устанавливаем состояние hasReachedMax
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
    if (currentState is CocktailSearchLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] = true;

      // Сначала эмитим состояние с флагом загрузки
      emit(currentState.copyWith(loadingStates: updatedLoadingStates));

      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);

        updatedLoadingStates[event.cocktailId] = false;

        // Обновляем данные коктейлей в избранном
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails());
        } else {
          // Обновляем локально коктейли, изменяя только `isFavorite`
          final updatedCocktails = currentState.cocktails.map((cocktail) {
            if (cocktail.id == event.cocktailId) {
              return cocktail.copyWith(
                  isFavorite: !cocktail.isFavorite); // Инверсия значения
            }
            return cocktail;
          }).toList();

          emit(currentState.copyWith(
            cocktails: updatedCocktails,
            loadingStates: updatedLoadingStates,
          ));
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

  void _onPublishCocktail(
      PublishCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;
    print("PublishCocktail event received: ${event.cocktailId}");
    print(currentState.toString());
    if (currentState is UserCocktailLoaded) {
      emit(CocktailLoading()); // Показать состояние загрузки
      print(currentState.toString());
      try {
        await repository.publishCocktail(event.cocktailId);
        final updatedCocktails = currentState.userCocktails.map((cocktail) {
          return cocktail.id == event.cocktailId
              ? cocktail.copyWith(
                  moderationStatus: 'Pending') // Обновляем статус
              : cocktail;
        }).toList();
        final updatedUserCocktails = await repository.fetchUserCocktails();

        emit(UserCocktailLoaded(updatedCocktails));
      } catch (e) {
        emit(CocktailError('Не удалось опубликовать коктейль: $e'));
      }
    }
  }
}
