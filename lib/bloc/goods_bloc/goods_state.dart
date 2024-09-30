part of 'goods_bloc.dart';

@immutable
abstract class GoodsState extends Equatable {
  const GoodsState();

  @override
  List<Object?> get props => [];
}

class GoodsInitial extends GoodsState {}

class GoodsLoading extends GoodsState {}

class GoodsLoaded extends GoodsState {
  final List<Product> goods;

  const GoodsLoaded(this.goods);

  @override
  List<Object?> get props => [goods];
}

class GoodsError extends GoodsState {
  final String message;

  const GoodsError(this.message);

  @override
  List<Object?> get props => [message];
}
