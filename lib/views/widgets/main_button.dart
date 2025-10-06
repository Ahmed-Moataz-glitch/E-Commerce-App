import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;
  final bool isLoading;
  const MainButton({
    super.key,
    this.title,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onTap,
      style: isLoading ? ElevatedButton.styleFrom() : ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: Size(size.width * 0.9, size.height * 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
    );
  }
}
