// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce_app/view_models/payment_methods_cubit/payment_methods_cubit.dart';
import 'package:e_commerce_app/views/widgets/checkout_headlines_item.dart';
import 'package:e_commerce_app/views/widgets/empty_shipping_payment.dart';
import 'package:e_commerce_app/views/widgets/label_with_value_row.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:e_commerce_app/views/widgets/payment_method_bottom_sheet.dart';
import 'package:e_commerce_app/views/widgets/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  
  Widget _buildPaymentMethodItem(PaymentCardModel? chosenCard,
      BuildContext context, CheckoutCubit checkoutCubit) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);
    final paymentCubit = BlocProvider.of<PaymentMethodsCubit>(context);
    if (chosenCard != null) {
      return PaymentMethodItem(
        paymentCard: chosenCard,
        onItemTapped: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return SizedBox(
                width: double.infinity,
                child: BlocProvider(
                  create: (context) {
                    final cubit = PaymentMethodsCubit();
                    cubit.fetchPaymentMethods();
                    return cubit;
                  },
                  child: const PaymentMethodBottomSheet(),
                ),
              );
            },
          ).then((value) async {
            checkoutCubit.getCheckoutContent();
            await paymentCubit.fetchPaymentMethods();
          });
        },
      );
    } else {
      return EmptyShippingAndPayment(
        title: 'Add Payment Method',
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.addNewCardRoute, arguments: paymentCubit)
              .then((value) async => await checkoutCubit.getCheckoutContent());
        },
      );
    }
  }

  Widget _buildShippingItem(
      LocationItemModel? chosenAddress, BuildContext context) {
    if (chosenAddress != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(16.0),
            child: CachedNetworkImage(
              imageUrl: chosenAddress.imgUrl,
              width: 140,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chosenAddress.city,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${chosenAddress.city}, ${chosenAddress.country}',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.grey,
                    ),
              ),
            ],
          ),
        ],
      );
    } else {
      return EmptyShippingAndPayment(
        title: 'Add shipping address',
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.chooseLocationRoute);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = CheckoutCubit();
            cubit.getCheckoutContent();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => PaymentMethodsCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          final cubit = BlocProvider.of<CheckoutCubit>(context);
          return BlocBuilder<CheckoutCubit, CheckoutState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is CheckoutLoaded ||
                current is CheckoutLoading ||
                current is CheckoutError,
            builder: (context, state) {
              if (state is CheckoutLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is CheckoutError) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is CheckoutLoaded) {
                final cartItems = state.cartItems;
                final chosenPaymentCard = state.chosenPaymentCard;
                final chosenAddress = state.chosenAddress;
                return SafeArea(
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        CheckoutHeadlinesItem(
                          title: 'Address',
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.chooseLocationRoute)
                                .then((value) async =>
                                    await cubit.getCheckoutContent());
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildShippingItem(chosenAddress, context),
                        const SizedBox(height: 24.0),
                        CheckoutHeadlinesItem(
                          title: 'Products',
                          numOfProducts: state.numOfProducts,
                        ),
                        const SizedBox(height: 16.0),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: AppColors.grey2,
                            );
                          },
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return Row(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.grey2,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: cartItem.product.imgUrl,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: 'Size: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: AppColors.grey,
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text: cartItem.size.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: cartItem.totalPrice
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: 'Quantity: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: AppColors.grey,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  cartItem.quantity.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        const CheckoutHeadlinesItem(title: 'Payment Methods'),
                        const SizedBox(height: 16.0),
                        _buildPaymentMethodItem(
                            chosenPaymentCard, context, cubit),
                        const SizedBox(height: 24.0),
                        Divider(
                          color: AppColors.grey2,
                        ),
                        const SizedBox(height: 8.0),
                        LabelWithValueRow(
                          label: 'Subtotal', 
                          value: '${state.subtotal.toStringAsFixed(1)} \$'
                        ),
                        const SizedBox(height: 12.0),
                        LabelWithValueRow(
                          label: 'Shipping', 
                          value: '${state.shippingValue.toStringAsFixed(1)} \$'
                        ),
                        const SizedBox(height: 12.0),
                        LabelWithValueRow(
                          label: 'Total Amount', 
                          value: '${state.totalAmount.toStringAsFixed(1)} \$'
                        ),
                        const SizedBox(height: 40.0),
                        MainButton(
                          title: 'Proceed to buy',
                          onTap: () {},
                        ),
                      ],
                    ),
                  )),
                );
              } else {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
