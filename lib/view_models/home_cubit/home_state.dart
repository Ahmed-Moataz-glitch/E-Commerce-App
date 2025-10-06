part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ProductItemModel> products;
  final List<HomeCarouselItemModel> carouselItems;

  HomeLoaded({required this.products, required this.carouselItems});
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

final class SetFavoriteLoading extends HomeState {
  final String productId;

  SetFavoriteLoading(this.productId);
}

final class SetFavoriteSuccess extends HomeState {
  final bool isFavorite;
  final String productId;

  SetFavoriteSuccess({required this.isFavorite, required this.productId});
}

final class SetFavoriteError extends HomeState {
  final String message;
  final String productId;

  SetFavoriteError(this.message, this.productId);
}
