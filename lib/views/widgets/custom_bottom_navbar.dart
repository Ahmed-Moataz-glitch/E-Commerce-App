// ignore_for_file: unused_field

import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/pages/cart_page.dart';
import 'package:e_commerce_app/views/pages/favorites_page.dart';
import 'package:e_commerce_app/views/pages/home_page.dart';
import 'package:e_commerce_app/views/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CustomBottomNavbar> {
  int selectedIndex = 0;
  List<PersistentTabConfig> tabs() => [
        PersistentTabConfig(
          screen: const HomePage(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const CartPage(),
          item: ItemConfig(
            icon: const Icon(CupertinoIcons.cart),
            title: "Cart",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const FavoritesPage(),
          item: ItemConfig(
            icon: const Icon(Icons.favorite_border),
            title: "Favorites",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const ProfilePage(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: "Profile",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: AppColors.grey,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/ahmed.jpeg'),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ahmed Moataz',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            'Let\'s go shopping!',
            style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(
                color: AppColors.grey,
              ),
          ),
          ],
      ),
      actions: [
        if (selectedIndex == 0) ...[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ]else if(selectedIndex == 1)
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.shopping_bag),
          ),
      ],
    ),
    body: PersistentTabView(
          tabs: tabs(),
          navBarBuilder: (navBarConfig) => Style6BottomNavBar(
            navBarConfig: navBarConfig,
          ),
          stateManagement: false,
          onTabChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
  );
}
