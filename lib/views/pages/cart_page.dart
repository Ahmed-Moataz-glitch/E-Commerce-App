import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/cart_item_widget.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) {
        final cubit = CartCubit();
        cubit.getCartDetails();
        return cubit;
      },
      child: Builder(builder: (context) {
        final cubit = BlocProvider.of<CartCubit>(context);
        return BlocBuilder<CartCubit, CartState>(
          bloc: cubit,
          buildWhen: (previous, current) =>
              current is CartLoaded ||
              current is CartLoading ||
              current is CartError,
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is CartError) {
              return const Center(
                child: Text('Error loading cart'),
              );
            } else if (state is CartLoaded) {
              final cartItems = state.cartItems;
              if (cartItems.isEmpty) {
                return const Center(
                  child: Text('No items in your cart'),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return CartItemWidget(cartItem: cartItem);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.grey2,
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                      Divider(
                        color: AppColors.grey3,
                      ),
                      SizedBox(height: size.height * 0.02),
                      BlocBuilder<CartCubit, CartState>(
                        bloc: cubit,
                        buildWhen: (previous, current) =>
                            current is SubtotalUpdated,
                        builder: (context, subtotalState) {
                          if (subtotalState is SubtotalUpdated) {
                            return Column(
                              children: [
                                subtotalAndTotal(context, 'Subtotal',
                                    subtotalState.subtotal),
                                SizedBox(height: size.height * 0.02),
                                subtotalAndTotal(context, 'Shipping', 10.0),
                                const SizedBox(height: 8.0),
                                Dash(
                                  dashColor: AppColors.grey3,
                                  length:
                                      MediaQuery.of(context).size.width - 32,
                                ),
                                const SizedBox(height: 8.0),
                                subtotalAndTotal(context, 'Total Amount',
                                    subtotalState.subtotal + 10.0),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              subtotalAndTotal(
                                  context, 'Subtotal', state.subtotal),
                              SizedBox(height: size.height * 0.02),
                              subtotalAndTotal(context, 'Shipping', 10.0),
                              const SizedBox(height: 8.0),
                              Dash(
                                dashColor: AppColors.grey3,
                                length: MediaQuery.of(context).size.width - 32,
                              ),
                              const SizedBox(height: 8.0),
                              subtotalAndTotal(context, 'Total Amount',
                                  state.subtotal + 10.0),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.1),
                      MainButton(
                        title: 'Checkout',
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.checkoutRoute);
                        }
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const Center(
                child: Text('Unexpected state'),
              );
            }
          },
        );
      }),
    );
  }
}

Widget subtotalAndTotal(
  BuildContext context,
  String title,
  double amount,
) {
  final size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.grey,
              ),
        ),
        Text(
          '${amount.toStringAsFixed(1)} \$',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  );
}
