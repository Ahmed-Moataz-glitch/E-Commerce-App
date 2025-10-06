part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<AddToCartModel> cartItems;
  final double subtotal;

  CartLoaded(this.cartItems, this.subtotal);
}

final class CartError extends CartState {
  final String message;

  CartError(this.message);
}

final class QuantityCounterLoaded extends CartState {
  final int value;
  final String productId;

  QuantityCounterLoaded(this.value, this.productId);
}

final class QuantityCounterLoading extends CartState {}

final class QuantityCounterError extends CartState {
  final String message;

  QuantityCounterError(this.message);
}


final class SubtotalUpdated extends CartState {
  final double subtotal;

  SubtotalUpdated(this.subtotal);
}
