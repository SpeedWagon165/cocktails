part of 'goods_bloc.dart';

abstract class GoodsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGoods extends GoodsEvent {}

class SearchGoods extends GoodsEvent {
  final String query;

  SearchGoods({required this.query});
}
