import 'package:flutter/material.dart';

class AuthButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;

  const AuthButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              child: Text(text),
            )
          : ElevatedButton(
              onPressed: onPressed,
              child: Text(text),
            ),
    );
  }
}
