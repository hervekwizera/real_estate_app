import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FormStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;
  final Function(int) onStepTapped;

  const FormStepIndicator({
    Key? key,
    required this.currentStep,
    required this.stepTitles,
    required this.onStepTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              stepTitles.length,
              (index) => _buildStepIndicator(context, index),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stepTitles[currentStep],
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, int index) {
    final theme = Theme.of(context);
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;

    final Color circleColor = isCompleted
        ? theme.colorScheme.primary
        : isActive
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest;

    final Color textColor = isCompleted || isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => onStepTapped(index),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isActive ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    )
                  : Text(
                      '${index + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stepTitles[index],
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
