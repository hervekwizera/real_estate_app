import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthIndicatorWidget extends StatelessWidget {
  final String strength;
  final double score;

  const PasswordStrengthIndicatorWidget({
    Key? key,
    required this.strength,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getStrengthColor() {
      if (score > 0.75) {
        return AppTheme.success;
      } else if (score > 0.5) {
        return AppTheme.warning;
      } else {
        return AppTheme.error;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength:',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              strength,
              style: theme.textTheme.bodySmall?.copyWith(
                color: getStrengthColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: score,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          color: getStrengthColor(),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}
