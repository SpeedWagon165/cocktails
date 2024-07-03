import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cocktail_setup_event.dart';

part 'cocktail_setup_state.dart';

class CocktailSelectionBloc
    extends Bloc<CocktailSelectionEvent, CocktailSelectionState> {
  CocktailSelectionBloc()
      : super(CocktailSelectionState({
          'Вино': [],
          'Водка': [],
          'Виски': [],
          'Шампанское': [],
          'Б/а напитки': [],
          'Продукты': []
        })) {
    on<ToggleSelectionEvent>(_toggleSelectionEvent);
    on<ClearSelectionEvent>(_clearSelectionEvent);
  }

  void _toggleSelectionEvent(
      ToggleSelectionEvent event, Emitter<CocktailSelectionState> emit) async {
    final currentSelection = state.selectedItems[event.category] ?? [];
    final updatedSelection = List<String>.from(currentSelection);

    if (updatedSelection.contains(event.item)) {
      updatedSelection.remove(event.item);
    } else {
      updatedSelection.add(event.item);
    }

    emit(state.copyWith({event.category: updatedSelection}));
  }

  void _clearSelectionEvent(
      ClearSelectionEvent event, Emitter<CocktailSelectionState> emit) async {
    emit(state.copyWith({event.category: []}));
  }
}
