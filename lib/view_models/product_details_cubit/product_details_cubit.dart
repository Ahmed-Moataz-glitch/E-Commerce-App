import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/services/product_details_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? size;
  int quantity = 1;

  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  void getProductDetailsData(String productId) async {
    emit(ProductDetailsLoading());
    try{
      final selectedProduct = await productDetailsServices.fetchProductDetails(productId);
      emit(ProductDetailsLoaded(selectedProduct));
    }catch(e){
      emit(ProductDetailsError(e.toString()));
    }
    // final selectedProduct =
    //     dummyProducts.firstWhere((product) => product.id == productId);
    // emit(ProductDetailsLoaded(selectedProduct));
  }

  void incrementCounter(String productId) {
    quantity++;
    emit(QuantityCounterLoaded(quantity));
  }

  void decrementCounter(String productId) {
    quantity--;
    emit(QuantityCounterLoaded(quantity));
  }

  void selectProductSize(ProductSize size) {
    this.size = size;
    emit(ProductSizeSelected(size));
  }
  

  Future<void> getAddToCartData(String productId) async {
    emit(AddToCartLoading());
    try{
      final selectedProduct = await productDetailsServices.fetchProductDetails(productId);
      final currentUser = authServices.currentUser();
      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        size: size!,
        quantity: quantity,
      );
      await productDetailsServices.addToCart(cartItem, currentUser!.uid);
      emit(AddToCartLoaded(productId));
    }catch(e){
      emit(AddToCartError(e.toString()));
    }
    final selectedProduct =
        dummyProducts.firstWhere((product) => product.id == productId);
    final cartItem = AddToCartModel(
      id: DateTime.now().toIso8601String(),
      product: selectedProduct,
      size: size!,
      quantity: quantity,
    );
    dummyCartItems.add(cartItem);
    Future.delayed(const Duration(seconds: 2), () {
      emit(AddToCartLoaded(cartItem.id));
    });
  }
}
