// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce_app/views/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is ProductDetailsLoading ||
          current is ProductDetailsLoaded ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;
          final selectedIndex =
              dummyProducts.indexWhere((product) => product.id == productId);
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('Product Details'),
              centerTitle: true,
              // actions: [
              //   IconButton(
              //     icon: const Icon(Icons.favorite_border),
              //     iconSize: 27,
              //     onPressed: () {},
              //   ),
              // ],
            ),
            body: Stack(
              children: [
                SizedBox(height: size.height * 0.58),
                Container(
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                    color: AppColors.grey2,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: CachedNetworkImage(
                          imageUrl: product.imgUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: size.height * 0.45),
                    Container(
                      height: size.height * 0.55,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                BlocBuilder<ProductDetailsCubit,
                                    ProductDetailsState>(
                                  bloc: cubit,
                                  buildWhen: (previous, current) =>
                                      current is QuantityCounterLoaded ||
                                      current is ProductDetailsLoaded,
                                  builder: (context, state) {
                                    if (state is QuantityCounterLoaded) {
                                      return CounterWidget(
                                        value: state.value,
                                        productId: product.id,
                                        cubit: cubit,
                                      );
                                    } else if (state is ProductDetailsLoaded) {
                                      return CounterWidget(
                                        value: 1,
                                        productId: product.id,
                                        cubit: cubit,
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.yellow,
                                  size: 25,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.product.averageRate.toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Size',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            BlocBuilder<ProductDetailsCubit,
                                ProductDetailsState>(
                              bloc: cubit,
                              buildWhen: (previous, current) =>
                                  current is ProductSizeSelected ||
                                  current is ProductDetailsLoaded,
                              builder: (context, state) {
                                return Row(
                                  children: ProductSize.values
                                      .map((size) => Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6, right: 8),
                                            child: InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                            ProductDetailsCubit>(
                                                        context)
                                                    .selectProductSize(size);
                                              },
                                              child: Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      state is ProductSizeSelected &&
                                                              state.size == size
                                                          ? AppColors.primary
                                                          : AppColors.grey2,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 6,
                                                  ),
                                                  child: Text(
                                                    size.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color: state
                                                                      is ProductSizeSelected &&
                                                                  state.size ==
                                                                      size
                                                              ? AppColors.white
                                                              : AppColors.black,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.product.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: AppColors.black45,
                                  ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: Text.rich(
                                    TextSpan(
                                        text: '${state.product.price}',
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
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: BlocBuilder<ProductDetailsCubit,
                                      ProductDetailsState>(
                                    bloc: cubit,
                                    buildWhen: (previous, current) =>
                                        current is AddToCartLoaded ||
                                        current is AddToCartLoading,
                                    builder: (context, state) {
                                      if (state is AddToCartLoading) {
                                        return ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: AppColors.white,
                                          ),
                                          child: const CircularProgressIndicator
                                              .adaptive(),
                                        );
                                      } else if (state is AddToCartLoaded) {
                                        return ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: AppColors.white,
                                          ),
                                          child: const Text('Added to cart'),
                                        );
                                      } else {
                                        return ElevatedButton.icon(
                                          onPressed: () {
                                            if (cubit.size != null) {
                                              cubit.getAddToCartData(productId);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Please select a size',
                                                ),
                                              ));
                                            }
                                          },
                                          label: Text(
                                            'Add to cart',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: AppColors.white,
                                                ),
                                          ),
                                          icon: const Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 24,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: AppColors.white,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: SizedBox.shrink(),
          );
        }
      },
    );
  }
}
