part of 'goods_bloc.dart';

abstract class GoodsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGoods extends GoodsEvent {}
