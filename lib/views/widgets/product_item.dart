// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 115,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.grey3,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CachedNetworkImage(
                  imageUrl: productItem.imgUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator.adaptive(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white54,
                ),
                child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: homeCubit,
                  buildWhen: (previous, current) =>
                      (current is SetFavoriteLoading && current.productId == productItem.id) ||
                      (current is SetFavoriteSuccess && current.productId == productItem.id) ||
                      (current is SetFavoriteError && current.productId == productItem.id),
                  builder: (context, state) {
                    if(state is SetFavoriteLoading) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is SetFavoriteSuccess) {
                      // return IconButton(
                      //   onPressed: () async =>
                      //       await homeCubit.setFavorite(productItem),
                      //   icon: productItem.isFavorite ? 
                      //   const Icon(Icons.favorite, color: Colors.red) :
                      //   const Icon(Icons.favorite_border),
                      // );
                      return state.isFavorite
                        ? InkWell(
                            onTap: () async =>
                              await homeCubit.setFavorite(productItem),
                            child: const IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: null,
                            ),
                          )
                        : InkWell(
                            onTap: () async =>
                              await homeCubit.setFavorite(productItem),
                            child: const IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                              ),
                              onPressed: null,
                            ),
                          );
                    }
                    // return IconButton(
                    //   onPressed: () async =>
                    //       await homeCubit.setFavorite(productItem),
                    //   icon: const Icon(Icons.favorite_border),
                    // );
                    return InkWell(
                      onTap: () async =>
                        await homeCubit.setFavorite(productItem),
                      child: productItem.isFavorite
                        ? const IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: null,
                          )
                        : const IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                            onPressed: null,
                          ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Text(
          productItem.name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          productItem.category,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Colors.grey,
              ),
        ),
        Text(
          '${productItem.price} \$',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
