import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NewCardInfo extends StatefulWidget {
  final bool visibility;
  final String? title;
  final IconData prefixIcon;
  final IconButton? suffixIcon;
  final String hintText;
  final TextEditingController controller;
  const NewCardInfo({
    super.key,
    this.title,
    required this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.controller, 
    this.visibility = false,
  });

  @override
  State<NewCardInfo> createState() => _NewCardInfoState();
}

class _NewCardInfoState extends State<NewCardInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null
            ? Text(
                widget.title!,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              )
            : const SizedBox(),
        const SizedBox(height: 6.0),
        TextFormField(
          obscureText: widget.visibility || widget.title != 'Password' ? false : true,
          validator: (value) => value == null || value.isEmpty
              ? '${widget.title} cannot be empty!'
              : null,
          controller: widget.controller,
          decoration: InputDecoration(
            fillColor: AppColors.grey2,
            filled: true,
            prefixIcon: Icon(
              widget.prefixIcon,
              size: 30,
            ),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
