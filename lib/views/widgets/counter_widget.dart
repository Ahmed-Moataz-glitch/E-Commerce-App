import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String? productId;
  final AddToCartModel? cartItem;
  final dynamic cubit;
  final int? initialValue;
  const CounterWidget({
    super.key, 
    required this.value, 
    this.productId,
    this.cartItem, 
    required this.cubit, 
    this.initialValue
  }) : assert(productId != null || cartItem != null);

  Future<void> decrementCounter(dynamic param) async {
    if (initialValue != null) {
      await cubit.decrementCounter(param, initialValue);
    } else {
      await cubit.decrementCounter(param);
    }
  }

  Future<void> incrementCounter(dynamic param) async {
    if (initialValue != null) {
      await cubit.incrementCounter(param, initialValue);
    } else {
      await cubit.incrementCounter(param);
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.width * 0.33,
          decoration: BoxDecoration(
            color: AppColors.grey2,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  cartItem != null ? cubit.decrementCounter(cartItem) : cubit.decrementCounter(productId);
                },
                icon: const Icon(
                  Icons.remove,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  cartItem != null ? cubit.incrementCounter(cartItem) : cubit.incrementCounter(productId);
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: size.width * 0.08),
      ],
    );
  }
}
