import 'package:e_commerce_app/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dummyCategories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: dummyCategories[index].bgColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      dummyCategories[index].name,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: dummyCategories[index].textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${dummyCategories[index].productsCount} Products',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: dummyCategories[index].textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
