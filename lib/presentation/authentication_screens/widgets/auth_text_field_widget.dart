import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AuthTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String prefixIcon;
  final String? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixIconTap;
  final List<TextInputFormatter>? inputFormatters;

  const AuthTextFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSuffixIconTap,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: CustomIconWidget(
          iconName: prefixIcon,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixIconTap,
                child: CustomIconWidget(
                  iconName: suffixIcon!,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
      ),
    );
  }
}
