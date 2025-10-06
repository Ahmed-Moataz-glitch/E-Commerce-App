import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/services/checkout_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymentMethodsInitial());

  String? selectedPaymentId;
  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> addNewCard(final String cardNumber, String cardHolderName,
      String cardExpiryDate, String cardCvv) async {
    emit(AddNewCardLoading());
    try {
      final PaymentCardModel newCard = PaymentCardModel(
        id: DateTime.now().toIso8601String(),
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expiryDate: cardExpiryDate,
        cvv: cardCvv,
      );
      final currentUser = authServices.currentUser();
      await checkoutServices.setCard(currentUser!.uid, newCard);
      emit(AddNewCardSuccess());
    } catch (e) {
      emit(AddNewCardFailure(e.toString()));
    }
  }

  Future<void> fetchPaymentMethods() async {
    emit(FetchingPaymentMethods());
    try {
      final currentUser = authServices.currentUser();
      final paymentCards =
          await checkoutServices.fetchPaymentMethods(currentUser!.uid);
      emit(FetchedPaymentMethods(paymentCards));
      final chosenPaymentMethod = paymentCards.firstWhere((element) => element.isChosen == true, orElse: () => paymentCards.first);
      selectedPaymentId = chosenPaymentMethod.id;
      emit(PaymentMethodChosen(chosenPaymentMethod));
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
  }

  Future<void> changePaymentMethod(String id) async {
    selectedPaymentId = id;
    try {
      final currentUser = authServices.currentUser();
      final tempChosenPaymentMethod = await checkoutServices
          .fetchSinglePaymentMethod(currentUser!.uid, selectedPaymentId!);
      emit(PaymentMethodChosen(tempChosenPaymentMethod));
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
  }

  Future<void> confirmPaymentMethod() async {
    emit(ConfirmPaymentLoading());
    try {
      final currentUser = authServices.currentUser();
      final previousChosenPayment = await checkoutServices.fetchPaymentMethods(currentUser!.uid, true);
      final previousChosenPaymentMethod = previousChosenPayment.first.copyWith(isChosen: false);
      await checkoutServices.setCard(currentUser.uid, previousChosenPaymentMethod);
      var chosenPaymentMethod = await checkoutServices.fetchSinglePaymentMethod(currentUser.uid, selectedPaymentId!);
      chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);
      await checkoutServices.setCard(currentUser.uid, chosenPaymentMethod);
      // Future.delayed(const Duration(seconds: 1), () {
        // var chosenPaymentMethod = dummyPaymentCards
        //     .firstWhere((paymentCard) => paymentCard.id == selectedPaymentId);
        // var previousPaymentMethod = dummyPaymentCards.firstWhere(
        //     (paymentCard) => paymentCard.isChosen == true,
        //     orElse: () => dummyPaymentCards.first);
        // previousPaymentMethod = previousPaymentMethod.copyWith(isChosen: false);
        // chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);
        // final preciousIndex = dummyPaymentCards.indexWhere(
        //     (paymentCard) => paymentCard.id == previousPaymentMethod.id);
        // final chosenIndex = dummyPaymentCards.indexWhere(
        //     (paymentCard) => paymentCard.id == chosenPaymentMethod.id);
        // dummyPaymentCards[preciousIndex] = previousPaymentMethod;
        // dummyPaymentCards[chosenIndex] = chosenPaymentMethod;
      // });
      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(ConfirmPaymentFailure(e.toString()));
    }
  }
}
