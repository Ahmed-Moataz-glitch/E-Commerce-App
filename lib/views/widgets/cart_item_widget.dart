import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<CartCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: size.height * 0.14,
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.grey2,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    height: size.height * 0.1,
                    width: size.width * 0.25,
                    imageUrl: cartItem.product.imgUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: size.height * 0.004),
                  Text.rich(
                    TextSpan(
                      text: 'Size: ',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.grey,
                          ),
                      children: [
                        TextSpan(
                          text: cartItem.size.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  BlocBuilder<CartCubit, CartState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is QuantityCounterLoaded &&
                        current.productId == cartItem.product.id,
                    builder: (context, state) {
                      if (state is QuantityCounterLoaded) {
                        return Row(
                          children: [
                            CounterWidget(
                              value: state.value,
                              productId: cartItem.product.id,
                              cubit: cubit,
                            ),
                            Text.rich(
                              TextSpan(
                                text: (state.value * cartItem.product.price)
                                    .toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                children: [
                                  TextSpan(
                                    text: ' \$',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                          children: [
                            CounterWidget(
                              value: cartItem.quantity,
                              cartItem: cartItem,
                              cubit: cubit,
                              initialValue: cartItem.quantity,
                            ),
                            Text.rich(
                              TextSpan(
                                text: cartItem.totalPrice.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                children: [
                                  TextSpan(
                                    text: ' \$',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
