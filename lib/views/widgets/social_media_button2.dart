import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SocialMediaButton2 extends StatelessWidget {
  final String? text;
  final String? img;
  final VoidCallback? onTap;
  final bool isLoading;

  SocialMediaButton2({
    super.key,
    this.text,
    this.img,
    this.onTap,
    this.isLoading = false,
  }){
    assert((text != null && img != null) || isLoading == true);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Image.asset(
                      img!,
                      width: 28,
                      height: 28,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(width: 20),
                    Text(text!),
                  ],
                ),
        ),
      ),
    );
  }
}
