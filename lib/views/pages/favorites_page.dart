import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      bloc: favoriteCubit,
      buildWhen: (previous, current) =>
          current is FavoriteLoaded ||
          current is FavoriteLoading ||
          current is FavoriteError,
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (state is FavoriteLoaded) {
          final favoriteProducts = state.favoriteProducts;
          return RefreshIndicator(
            onRefresh: () async {
              await favoriteCubit.getFavoriteProducts();
            },
            child: favoriteProducts.isEmpty
                ? ListView.builder(
                  itemCount: 1,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.3,
                          top: size.height * 0.4,
                        ),
                        child: const Text(
                          'No favorite products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: ListView.separated(
                      itemCount: favoriteProducts.length,
                      separatorBuilder: (context, index) {
                  return Divider(
                    indent: 20,
                    endIndent: 20,
                    color: AppColors.grey2,
                  );
                },
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    title: Text(product.name),
                    subtitle: Text(product.price.toString()),
                    leading: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.grey2,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CachedNetworkImage(
                          imageUrl: product.imgUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator.adaptive(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    trailing: BlocConsumer<FavoriteCubit, FavoriteState>(
                      bloc: favoriteCubit,
                      listenWhen: (previous, current) => current is FavoriteRemoveError,
                      listener: (context, state) {
                        if (state is FavoriteRemoveError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        } 
                      },
                      buildWhen: (previous, current) =>
                          (current is FavoriteRemoving &&
                              current.productId == product.id) ||
                          (current is FavoriteRemoved &&
                              current.productId == product.id) ||
                          current is FavoriteRemoveError,
                      builder: (context, state) {
                        if (state is FavoriteRemoving) {
                          return const CircularProgressIndicator.adaptive();
                        }
                        return IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.red,
                          ),
                          onPressed: () async {
                            await favoriteCubit.removeFavorite(product.id);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is FavoriteError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}