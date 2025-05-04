import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NumericStepper extends StatelessWidget {
  final num value;
  final num min;
  final num max;
  final bool allowHalf;
  final Function(num) onChanged;

  const NumericStepper({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    this.allowHalf = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _buildButton(
          context,
          icon: 'remove',
          onPressed: value > min
              ? () {
                  final newValue = allowHalf ? value - 0.5 : value - 1;
                  if (newValue >= min) {
                    onChanged(newValue);
                  }
                }
              : null,
        ),
        Container(
          width: 50,
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildButton(
          context,
          icon: 'add',
          onPressed: value < max
              ? () {
                  final newValue = allowHalf ? value + 0.5 : value + 1;
                  if (newValue <= max) {
                    onChanged(newValue);
                  }
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context,
      {required String icon, VoidCallback? onPressed}) {
    final theme = Theme.of(context);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: onPressed != null
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerHighest.withAlpha(128),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: CustomIconWidget(
          iconName: icon,
          size: 18,
          color: onPressed != null
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurfaceVariant.withAlpha(128),
        ),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}
