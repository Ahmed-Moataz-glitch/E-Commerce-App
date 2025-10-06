part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  final ProductItemModel product;

  ProductDetailsLoaded(this.product);
}

final class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError(this.message);
}

final class QuantityCounterLoaded extends ProductDetailsState {
  final int value;

  QuantityCounterLoaded(this.value);
}

final class ProductSizeSelected extends ProductDetailsState {
  final ProductSize size;

  ProductSizeSelected(this.size);
}

final class AddToCartLoading extends ProductDetailsState {}

final class AddToCartLoaded extends ProductDetailsState {
  final String productId;

  AddToCartLoaded(this.productId);
}

final class AddToCartError extends ProductDetailsState {
  final String message;

  AddToCartError(this.message);
}

final class SetFavoriteLoading extends ProductDetailsState {
  final String productId;

  SetFavoriteLoading(this.productId);
}

final class SetFavoriteSuccess extends ProductDetailsState {
  final bool isFavorite;
  final String productId;

  SetFavoriteSuccess({required this.isFavorite, required this.productId});
}

final class SetFavoriteError extends ProductDetailsState {
  final String message;
  final String productId;

  SetFavoriteError(this.message, this.productId);
}
