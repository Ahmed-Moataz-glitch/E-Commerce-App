import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:e_commerce_app/views/widgets/category_tab_view.dart';
import 'package:e_commerce_app/views/widgets/home_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeCubit = HomeCubit();
        homeCubit.getHomeData(); // Assuming you have a method to load data
        return homeCubit;
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         const CircleAvatar(
              //           radius: 25,
              //           backgroundImage: AssetImage('assets/images/ahmed.jpeg'),
              //         ),
              //         const SizedBox(width: 16),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Ahmed Moataz',
              //               style: Theme.of(context).textTheme.labelLarge,
              //             ),
              //             Text(
              //               'Let\'s go shopping!',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .labelSmall!
              //                   .copyWith(
              //                     color: Colors.grey,
              //                   ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         IconButton(
              //           onPressed: () {},
              //           icon: const Icon(Icons.search),
              //         ),
              //         IconButton(
              //           onPressed: () {},
              //           icon: const Icon(Icons.notifications),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
              const SizedBox(height: 24),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                unselectedLabelColor: AppColors.grey,
                tabs: const [
                  Tab(
                    child: Text(
                      'Home',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Category',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    HomeTabView(),
                    CategoryTabView(), // Assuming you have a CategoryTabView widget
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
