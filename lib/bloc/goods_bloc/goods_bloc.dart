import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  }
}
