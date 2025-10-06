import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          bloc: cubit,
          listenWhen: (previous, current) => current is AuthLogOutError || current is AuthLoggedOut,
          listener: (context, state) {
            if(state is AuthLoggedOut) {
              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                AppRoutes.loginRoute,
                (route) => false,
              );
            } else if (state is AuthLogOutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          buildWhen: (previous, current) => current is AuthLoggingOut,
          builder: (context, state) {
            if(state is AuthLoggingOut) {
              return MainButton(
                isLoading: true,
                onTap: () {},
              );
            }
            return MainButton(
              title: 'Logout',
              onTap: () async => await cubit.logout(),
            );
          },
        ),
      ),
    );
  }
}
