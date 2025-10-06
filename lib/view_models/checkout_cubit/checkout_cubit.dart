// ignore_for_file: prefer_const_declarations

import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/services/cart_services.dart';
import 'package:e_commerce_app/services/checkout_services.dart';
import 'package:e_commerce_app/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();
  final locationServices = LocationServicesImpl();
  final cartServices = CartServicesImpl();

  Future<void> getCheckoutContent() async {
    emit(CheckoutLoading());
    try {
      final currentUser = authServices.currentUser();
      final cartItems = await cartServices.fetchCartItems(currentUser!.uid);
      double shippingValue = 10;
      final subtotal = cartItems.fold<double>(
          0,
          (previousValue, item) =>
              previousValue + (item.product.price * item.quantity));
      final numOfProducts = cartItems.fold<int>(
          0, (previousValue, item) => previousValue + item.quantity);
      final chosenPaymentCard =
          // dummyPaymentCards.isNotEmpty ? dummyPaymentCards.first : null;
          (await checkoutServices.fetchPaymentMethods(currentUser.uid, true))
              .first;
      final chosenAddress =
          // dummyLocations.isNotEmpty ? dummyLocations.first : null;
          (await locationServices.fetchLocations(currentUser.uid, true)).first;
      emit(CheckoutLoaded(cartItems: cartItems, subtotal: subtotal, shippingValue: shippingValue, totalAmount: subtotal + shippingValue, numOfProducts: numOfProducts,
          chosenPaymentCard: chosenPaymentCard, chosenAddress: chosenAddress));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
