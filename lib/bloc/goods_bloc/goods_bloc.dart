import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/store_model.dart';
import '../../provider/store_repository.dart';

part 'goods_event.dart';
part 'goods_state.dart';

class GoodsBloc extends Bloc<GoodsEvent, GoodsState> {
  final GoodsRepository repository;

  GoodsBloc(this.repository) : super(GoodsInitial()) {
    on<FetchGoods>((event, emit) async {
      emit(GoodsLoading());
      try {
        final goods = await repository.fetchGoods();
        emit(GoodsLoaded(goods));
      } catch (e) {
        emit(GoodsError('Failed to load goods: $e'));
      }
    });
    on<SearchGoods>((event, emit) async {
      emit(GoodsLoading());
      try {
        final goods = await repository.searchGoods(event.query);
        emit(GoodsLoaded(goods));
      } catch (e) {
        emit(GoodsError('Failed to search goods: $e'));
      }
    });
  }
}
